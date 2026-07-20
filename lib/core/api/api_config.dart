class ApiConfig {
  ApiConfig._();

  // default app currency
  static const String baseCurrency = 'egp';

  /// The default base URL for the latest currency rates.
  static const String baseUrlLatest = 'https://latest.currency-api.pages.dev/v1';

  // fetch currency exchange rate by date
  static String baseUrlHistorical(String date) =>
      'https://$date.currency-api.pages.dev/v1';

  static String get currenciesPath => '/currencies/$baseCurrency.json';
  static String get latestEgpUrl => '$baseUrlLatest$currenciesPath';
}
