import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_local_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_remote_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CurrencyExchange>> getTodayAndYesterdayRates() async {
    try {
      final remoteRates = await remoteDataSource.getTodayAndYesterdayRates();
      await localDataSource.cacheCurrencyRates(remoteRates);
      return remoteRates;
    } catch (e) {
      try {
        final localRates = await localDataSource.getLastCurrencyRates();
        return localRates;
      } catch (cacheError) {
        rethrow;
      }
    }
  }

  @override
  Future<List<CurrencyExchange>> getLastSevenDaysRates() async {
    try {
      final remoteRates = await remoteDataSource.getLastSevenDaysRates();
      await localDataSource.cacheHistoricalRates(remoteRates);
      return remoteRates;
    } catch (e) {
      try {
        final localRates = await localDataSource.getLastHistoricalRates();
        return localRates;
      } catch (cacheError) {
        rethrow;
      }
    }
  }
}
