import 'package:currency_exchange_tracker/core/error/exceptions.dart';
import 'package:currency_exchange_tracker/core/error/failures.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_local_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_remote_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/entities/currency_exchange.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/repositories/currency_repository.dart';
import 'package:dartz/dartz.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CurrencyExchange>>> getTodayAndYesterdayRates() async {
    try {
      final remoteRates = await remoteDataSource.getTodayAndYesterdayRates();
      await localDataSource.cacheCurrencyRates(remoteRates);
      return Right(remoteRates);
    } on NetworkException catch (e) {
      try {
        final localRates = await localDataSource.getLastCurrencyRates();
        return Right(localRates);
      } on CacheException {
        return const Left(NetworkFailure("It looks like you're offline. We couldn't find any saved rates to show you right now."));
      }
    } on ServerException catch (e) {
      try {
        final localRates = await localDataSource.getLastCurrencyRates();
        return Right(localRates);
      } on CacheException {
        return const Left(ServerFailure("We're having trouble reaching the server. No saved data is available at the moment."));
      }
    } catch (e) {
      return const Left(ServerFailure("Oops! Something went wrong on our end. Please try again in a bit."));
    }
  }

  @override
  Future<Either<Failure, List<CurrencyExchange>>> getLastSevenDaysRates() async {
    try {
      final remoteRates = await remoteDataSource.getLastSevenDaysRates();
      await localDataSource.cacheHistoricalRates(remoteRates);
      return Right(remoteRates);
    } on NetworkException catch (e) {
      try {
        final localRates = await localDataSource.getLastHistoricalRates();
        return Right(localRates);
      } on CacheException {
        return const Left(NetworkFailure("You're offline, and we don't have any saved history to display yet."));
      }
    } on ServerException catch (e) {
      try {
        final localRates = await localDataSource.getLastHistoricalRates();
        return Right(localRates);
      } on CacheException {
        return const Left(ServerFailure("The server is taking a little too long to respond. No saved history was found."));
      }
    } catch (e) {
      return const Left(ServerFailure("We hit a snag loading the history. Let's try that again."));
    }
  }
}
