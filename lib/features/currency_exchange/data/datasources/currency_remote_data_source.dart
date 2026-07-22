import 'package:currency_exchange_tracker/core/api/api_config.dart';
import 'package:currency_exchange_tracker/core/error/exceptions.dart';
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
      throw ServerException('Failed to load latest rates');
    }
  }

  @override
  Future<CurrencyResponseModel> getHistoricalRates(String date) async {
    final url = '${ApiConfig.baseUrlHistorical(date)}${ApiConfig.currenciesPath}';
    final response = await dioClient.get(url);
    if (response.statusCode == 200) {
      return CurrencyResponseModel.fromRemoteJson(response.data);
    } else {
      throw ServerException('Failed to load rates for $date');
    }
  }
  @override
  Future<List<CurrencyResponseModel>> getTodayAndYesterdayRates() async {
    // 1. Fetch the latest rates FIRST
    final latestRates = await getLatestRates();

    // 2. Extract the actual date of the latest data.
    // (Adjust 'latestRates.date' based on your actual model properties)
    final apiLatestDate = DateTime.parse(latestRates.date);

    // 3. Calculate yesterday based on the API's date, not the device's date
    final yesterday = apiLatestDate.subtract(const Duration(days: 1));
    final yesterdayDateStr = yesterday.toIso8601String().split('T')[0];

    // 4. Fetch yesterday's rates
    final yesterdayRates = await getHistoricalRates(yesterdayDateStr);

    return [latestRates, yesterdayRates];
  }

  @override
  Future<List<CurrencyResponseModel>> getLastSevenDaysRates() async {
    // 1. Fetch latest first to get the anchor date
    final latestRates = await getLatestRates();
    final apiLatestDate = DateTime.parse(latestRates.date);

    final List<Future<CurrencyResponseModel>> futures = [];

    // We already have the latest rates (day 0), so add it directly as a completed Future
    futures.add(Future.value(latestRates));

    // 2. Loop for the remaining 6 days, calculating backwards from the API's latest date
    for (int i = 1; i < 7; i++) {
      final pastDate = apiLatestDate.subtract(Duration(days: i));
      final dateStr = pastDate.toIso8601String().split('T')[0];

      futures.add(getHistoricalRates(dateStr));
    }

    // 3. Wait for the remaining 6 API calls concurrently
    return await Future.wait(futures);
  }
}
