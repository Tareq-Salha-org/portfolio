import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Result of a contact form submission attempt.
///
/// [success] mirrors the Web3Forms response; [message] carries a human
/// readable description (may be the server's message or a local error).
class ContactFormResult {
  final bool success;
  final String message;

  const ContactFormResult.success(this.message) : success = true;
  const ContactFormResult.failure(this.message) : success = false;
}

/// Thin client for the Web3Forms API.
///
/// Only the contact form talks to this service, so no DI framework is needed —
/// a single static entry point keeps the integration testable and easy to
/// swap for another provider later.
class ContactService {
  ContactService._();

  /// Posts the message to Web3Forms.
  ///
  /// Never throws: every failure mode (network, timeout, server error) is
  /// mapped to a [ContactFormResult.failure] so callers can render UI without
  /// try/catch noise.
  static Future<ContactFormResult> submit({
    required String name,
    required String email,
    required String message,
  }) async {
    final client = http.Client();
    try {
      final response = await client
          .post(
            Uri.parse(AppConfig.web3FormsEndpoint),
            headers: const {'Accept': 'application/json'},
            body: {
              'access_key': AppConfig.web3FormsAccessKey,
              'name': name,
              'email': email,
              'message': message,
              'subject': 'Portfolio inquiry from $name',
              'from_name': name,
              // Lets the owner reply straight to the sender.
              'replyto': email,
              // Honeypot field — Web3Forms drops submissions that fill it.
              // It is never rendered, so it always stays empty.
              'botcheck': '',
            },
          )
          .timeout(AppConfig.web3FormsTimeout);

      final body = response.body;
      final success = _isSuccess(response.statusCode, body);
      final serverMessage = _extractMessage(body);

      if (success) {
        return ContactFormResult.success(
          serverMessage.isNotEmpty ? serverMessage : 'Message sent.',
        );
      }
      return ContactFormResult.failure(
        serverMessage.isNotEmpty
            ? serverMessage
            : 'Submission failed with status ${response.statusCode}.',
      );
    } on TimeoutException {
      return const ContactFormResult.failure(
        'The request timed out. Please try again.',
      );
    } catch (_) {
      return const ContactFormResult.failure(
        'Could not reach the mail service. Please check your connection and '
        'try again.',
      );
    } finally {
      client.close();
    }
  }

  static bool _isSuccess(int statusCode, String body) {
    if (statusCode >= 200 && statusCode < 300) {
      // Web3Forms answers 200 with a JSON body even on business errors, so
      // the `success` flag is the authoritative signal.
      final success = _jsonField(body, 'success');
      return success == null || success == true || success == 'true';
    }
    return false;
  }

  static String _extractMessage(String body) {
    final message = _jsonField(body, 'message');
    if (message == null || message == false || message == '') return '';
    return message.toString();
  }

  /// Tries to read a top-level JSON string/bool field without pulling in a
  /// JSON dependency in the hot path (only used for display strings).
  static Object? _jsonField(String body, String key) {
    final index = body.indexOf('"$key"');
    if (index < 0) return null;
    final after = body.substring(index + key.length + 3).trimLeft();
    if (after.isEmpty) return null;
    if (after.startsWith('"')) {
      final end = after.indexOf('"', 1);
      if (end < 0) return null;
      return after.substring(1, end).replaceAll('\\"', '"');
    }
    final end = after.indexOf(',');
    final raw = end < 0 ? after : after.substring(0, end);
    final trimmed = raw.trim();
    if (trimmed == 'true') return true;
    if (trimmed == 'false') return false;
    return trimmed;
  }
}
