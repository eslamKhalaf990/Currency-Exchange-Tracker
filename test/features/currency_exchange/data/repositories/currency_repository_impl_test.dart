import 'package:currency_exchange_tracker/core/error/exceptions.dart';
import 'package:currency_exchange_tracker/core/error/failures.dart';
import 'package:currency_exchange_tracker/core/network/network_info.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_local_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_remote_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/models/currency_response_model.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/repositories/currency_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockRemoteDataSource extends Mock implements CurrencyRemoteDataSource {}

class MockLocalDataSource extends Mock implements CurrencyLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CurrencyRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CurrencyRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getTodayAndYesterdayRates', () {
    final tCurrencyExchange = [
      CurrencyResponseModel(
        date: "2026-07-22",
        rates: {
          "usd": 0.019227,
          "eur": 0.016525
        },
      )
    ];

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTodayAndYesterdayRates())
          .thenAnswer((_) async => tCurrencyExchange);
      when(() => mockLocalDataSource.cacheCurrencyRates(any()))
          .thenAnswer((_) async => {});

      // act
      await repository.getTodayAndYesterdayRates();

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTodayAndYesterdayRates())
              .thenAnswer((_) async => tCurrencyExchange);
          when(() => mockLocalDataSource.cacheCurrencyRates(any()))
              .thenAnswer((_) async => {});

          // act
          final result = await repository.getTodayAndYesterdayRates();

          // assert
          verify(() => mockRemoteDataSource.getTodayAndYesterdayRates());
          expect(result, equals(Right(tCurrencyExchange)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTodayAndYesterdayRates())
              .thenAnswer((_) async => tCurrencyExchange);
          when(() => mockLocalDataSource.cacheCurrencyRates(any()))
              .thenAnswer((_) async => {});

          // act
          await repository.getTodayAndYesterdayRates();

          // assert
          verify(() => mockRemoteDataSource.getTodayAndYesterdayRates());
          verify(() => mockLocalDataSource.cacheCurrencyRates(tCurrencyExchange));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTodayAndYesterdayRates())
              .thenThrow(ServerException());

          // act
          final result = await repository.getTodayAndYesterdayRates();

          // assert
          verify(() => mockRemoteDataSource.getTodayAndYesterdayRates());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure("We're having trouble reaching the server. No saved data is available at the moment."))));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastCurrencyRates())
              .thenAnswer((_) async => tCurrencyExchange);

          // act
          final result = await repository.getTodayAndYesterdayRates();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastCurrencyRates());
          expect(result, equals(Right(tCurrencyExchange)));
        },
      );

      test(
        'should return NetworkFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastCurrencyRates())
              .thenThrow(CacheException());

          // act
          final result = await repository.getTodayAndYesterdayRates();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastCurrencyRates());
          expect(result, equals(const Left(NetworkFailure("It looks like you're offline. We couldn't find any saved rates to show you right now."))));
        },
      );
    });
  });

  group('getLastSevenDaysRates', () {
    final tCurrencyExchangeList = [
      CurrencyResponseModel(
        date: "2026-07-22",
        rates: {
          "usd": 0.019227,
          "eur": 0.016525
        },
      )
    ];

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getLastSevenDaysRates())
          .thenAnswer((_) async => tCurrencyExchangeList);
      when(() => mockLocalDataSource.cacheHistoricalRates(any()))
          .thenAnswer((_) async => {});

      // act
      await repository.getLastSevenDaysRates();

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getLastSevenDaysRates())
              .thenAnswer((_) async => tCurrencyExchangeList);
          when(() => mockLocalDataSource.cacheHistoricalRates(any()))
              .thenAnswer((_) async => {});

          // act
          final result = await repository.getLastSevenDaysRates();

          // assert
          verify(() => mockRemoteDataSource.getLastSevenDaysRates());
          expect(result, equals(Right(tCurrencyExchangeList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getLastSevenDaysRates())
              .thenAnswer((_) async => tCurrencyExchangeList);
          when(() => mockLocalDataSource.cacheHistoricalRates(any()))
              .thenAnswer((_) async => {});

          // act
          await repository.getLastSevenDaysRates();

          // assert
          verify(() => mockRemoteDataSource.getLastSevenDaysRates());
          verify(() => mockLocalDataSource.cacheHistoricalRates(tCurrencyExchangeList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getLastSevenDaysRates())
              .thenThrow(ServerException());

          // act
          final result = await repository.getLastSevenDaysRates();

          // assert
          verify(() => mockRemoteDataSource.getLastSevenDaysRates());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure("The server is taking a little too long to respond. No saved history was found."))));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastHistoricalRates())
              .thenAnswer((_) async => tCurrencyExchangeList);

          // act
          final result = await repository.getLastSevenDaysRates();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastHistoricalRates());
          expect(result, equals(Right(tCurrencyExchangeList)));
        },
      );

      test(
        'should return NetworkFailure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastHistoricalRates())
              .thenThrow(CacheException());

          // act
          final result = await repository.getLastSevenDaysRates();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastHistoricalRates());
          expect(result, equals(const Left(NetworkFailure("You're offline, and we don't have any saved history to display yet."))));
        },
      );
    });
  });
}
