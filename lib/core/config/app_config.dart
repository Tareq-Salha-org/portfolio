/// Central configuration for third-party services used by the portfolio.
///
/// The Web3Forms access key is intentionally a *public* client-side key — it
/// is meant to be shipped in the web bundle, exactly like an analytics ID.
/// Keeping it in one place makes it easy to update when the key changes.
class AppConfig {
  AppConfig._();

  /// Web3Forms submission endpoint.
  static const String web3FormsEndpoint = 'https://api.web3forms.com/submit';

  /// Public access key that maps submissions to this portfolio's inbox.
  static const String web3FormsAccessKey =
      'cc6aae94-8e87-4672-b913-ebe254974e0a';

  /// Request timeout — generous enough for slow mobile networks.
  static const Duration web3FormsTimeout = Duration(seconds: 20);
}
