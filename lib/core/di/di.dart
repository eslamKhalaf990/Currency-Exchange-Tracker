import 'package:currency_exchange_tracker/core/network/dio_client.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_local_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/datasources/currency_remote_data_source.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/repositories/currency_repository_impl.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/repositories/currency_repository.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/usecases/get_exchange_rates_usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/domain/usecases/get_historical_rates_usecase.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/presentation/bloc/rates_list_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Currency Exchange
  // Bloc
  sl.registerFactory(() => RatesListBloc(getExchangeRatesUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetExchangeRatesUseCase(sl()));
  sl.registerLazySingleton(() => GetHistoricalRatesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => DioClient(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
