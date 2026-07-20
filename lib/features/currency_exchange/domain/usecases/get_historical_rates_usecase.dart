import 'package:currency_exchange_tracker/core/usecases/usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/repositories/currency_repository.dart';

class GetHistoricalRatesUseCase implements UseCase<List<CurrencyExchange>, NoParams> {
  final CurrencyRepository repository;

  GetHistoricalRatesUseCase(this.repository);

  @override
  Future<List<CurrencyExchange>> call(NoParams params) async {
    return await repository.getLastSevenDaysRates();
  }
}
