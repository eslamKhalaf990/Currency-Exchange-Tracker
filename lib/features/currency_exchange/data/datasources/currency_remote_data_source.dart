import 'package:currency_exchange_tracker/core/api/api_config.dart';
import 'package:currency_exchange_tracker/core/network/dio_client.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/models/currency_response_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<CurrencyResponseModel> getLatestRates();
  Future<CurrencyResponseModel> getHistoricalRates(String date);
  Future<List<CurrencyResponseModel>> getTodayAndYesterdayRates();
  Future<List<CurrencyResponseModel>> getLastSevenDaysRates();
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final DioClient dioClient;

  CurrencyRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CurrencyResponseModel> getLatestRates() async {
    final response = await dioClient.get(ApiConfig.latestEgpUrl);
    if (response.statusCode == 200) {
      return CurrencyResponseModel.fromRemoteJson(response.data);
    } else {
      throw Exception('Failed to load latest rates');
    }
  }

  @override
  Future<CurrencyResponseModel> getHistoricalRates(String date) async {
    final url = '${ApiConfig.baseUrlHistorical(date)}${ApiConfig.currenciesPath}';
    final response = await dioClient.get(url);
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

  @override
  Future<List<CurrencyResponseModel>> getLastSevenDaysRates() async {
    final List<Future<CurrencyResponseModel>> futures = [];
    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];
      if (i == 0) {
        futures.add(getLatestRates());
      } else {
        futures.add(getHistoricalRates(dateStr));
      }
    }

    return await Future.wait(futures);
  }
}
