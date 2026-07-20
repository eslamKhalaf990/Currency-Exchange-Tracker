import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_exchange_tracker/features/currency_exchange/data/models/currency_response_model.dart';

abstract class CurrencyLocalDataSource {
  Future<void> cacheCurrencyRates(List<CurrencyResponseModel> rates);
  Future<List<CurrencyResponseModel>> getLastCurrencyRates();
}

const cachedRatesKey = 'CACHED_CURRENCY_RATES';

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheCurrencyRates(List<CurrencyResponseModel> rates) {
    final List<String> ratesJsonList = rates.map((rate) => jsonEncode(rate.toJson())).toList();
    return sharedPreferences.setStringList(cachedRatesKey, ratesJsonList);
  }

  @override
  Future<List<CurrencyResponseModel>> getLastCurrencyRates() {
    final jsonList = sharedPreferences.getStringList(cachedRatesKey);
    if (jsonList != null && jsonList.isNotEmpty) {
      return Future.value(jsonList
          .map((item) => CurrencyResponseModel.fromJson(jsonDecode(item)))
          .toList());
    } else {
      throw Exception('No cached rates found');
    }
  }
}
