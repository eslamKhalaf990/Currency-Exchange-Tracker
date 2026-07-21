import 'package:currency_exchange_tracker/core/error/failures.dart';
import 'package:currency_exchange_tracker/core/usecases/usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/repositories/currency_repository.dart';
import 'package:dartz/dartz.dart';

class GetExchangeRatesUseCase implements UseCase<List<CurrencyExchange>, NoParams> {
  final CurrencyRepository repository;

  GetExchangeRatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CurrencyExchange>>> call(NoParams params) async {
    return await repository.getTodayAndYesterdayRates();
  }
}
