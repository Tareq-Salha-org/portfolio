import 'package:url_launcher/url_launcher.dart';

/// Helpers for launching external URLs (browser tabs, email, phone).
class AppLinks {
  AppLinks._();

  /// Opens any URL in the appropriate external target (new tab on web,
  /// default app for mailto: / tel: schemes).
  static Future<void> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Builds a `mailto:` URI with optional subject/body.
  static String mailto(String email, {String subject = '', String body = ''}) {
    final qs = Uri(
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    ).query;
    return 'mailto:$email${qs.isEmpty ? '' : '?$qs'}';
  }
}
