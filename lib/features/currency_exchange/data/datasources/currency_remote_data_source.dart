import 'package:dio/dio.dart';
import 'package:currency_exchange_tracker/core/api/api_config.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/models/currency_response_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<CurrencyResponseModel> getLatestRates();
  Future<CurrencyResponseModel> getHistoricalRates(String date);
  Future<List<CurrencyResponseModel>> getTodayAndYesterdayRates();
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});

  @override
  Future<CurrencyResponseModel> getLatestRates() async {
    final response = await dio.get(ApiConfig.latestEgpUrl);
    if (response.statusCode == 200) {
      return CurrencyResponseModel.fromRemoteJson(response.data);
    } else {
      throw Exception('Failed to load latest rates');
    }
  }

  @override
  Future<CurrencyResponseModel> getHistoricalRates(String date) async {
    final url = '${ApiConfig.baseUrlHistorical(date)}${ApiConfig.currenciesPath}';
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return CurrencyResponseModel.fromRemoteJson(response.data);
    } else {
      throw Exception('Failed to load rates for $date');
    }
  }

  @override
  Future<List<CurrencyResponseModel>> getTodayAndYesterdayRates() async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    final yesterdayDateStr = yesterday.toIso8601String().split('T')[0];

    // Fetching today's (latest) and yesterday's rates concurrently
    final results = await Future.wait([
      getLatestRates(),
      getHistoricalRates(yesterdayDateStr),
    ]);

    return results;
  }
}
