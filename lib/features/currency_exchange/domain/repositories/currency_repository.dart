import 'package:currency_exchange_tracker/core/error/failures.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:dartz/dartz.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<CurrencyExchange>>> getTodayAndYesterdayRates();
  Future<Either<Failure, List<CurrencyExchange>>> getLastSevenDaysRates();
}
