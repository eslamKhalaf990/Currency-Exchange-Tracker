import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyExchange>> getTodayAndYesterdayRates();
  Future<List<CurrencyExchange>> getLastSevenDaysRates();
}
