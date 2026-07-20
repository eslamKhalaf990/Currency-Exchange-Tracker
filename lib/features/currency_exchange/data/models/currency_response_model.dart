import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';

class CurrencyResponseModel extends CurrencyExchange {
  const CurrencyResponseModel({
    required super.date,
    required super.rates,
  });

  factory CurrencyResponseModel.fromJson(Map<String, dynamic> json) {
    final String date = json['date'] as String? ?? '';
    final ratesMap = json['egp'] as Map<String, dynamic>? ?? {};

    // The API provides rates as: 1 EGP = X [Foreign Currency]
    // We invert it to store: 1 [Foreign Currency] = Y EGP
    // Example: If 1 EGP = 0.02 USD, then 1 USD = 1 / 0.02 = 50 EGP
    final rates = ratesMap.map<String, double>((key, value) {
      final double rateAgainstEgp = (value as num?)?.toDouble() ?? 0.0;
      final double egpPerUnit = rateAgainstEgp != 0 ? 1.0 / rateAgainstEgp : 0.0;
      return MapEntry(key, egpPerUnit);
    });

    return CurrencyResponseModel(
      date: date,
      rates: rates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'egp': rates,
    };
  }

  CurrencyExchange toEntity() {
    return CurrencyExchange(
      date: date,
      rates: rates,
    );
  }
}
