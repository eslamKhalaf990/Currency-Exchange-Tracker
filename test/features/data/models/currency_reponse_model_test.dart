import 'package:currency_exchange_tracker/features/currency_exchange/data/models/currency_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('CurrencyResponseModel Inversion Math Tests', () {

    // 1. test inversion math
    test('should parse the JSON response correctly', () async {
      final Map<String, dynamic> jsonMap = {
        "date": "2026-07-22",
        "egp": {
          "usd": 0.019227,
          "eur": 0.016525
        },
      };

      // act
      final result = CurrencyResponseModel.fromRemoteJson(jsonMap);

      // assert
      expect(result.date, "2026-07-22");

      final usdRate = result.rates['usd'];
      expect(usdRate, closeTo(52.01, 0.01));

      final eurRate = result.rates['eur'];
      expect(eurRate, closeTo(60.51, 0.01));
    });

    // 2. test division by zero
    test('should parse the JSON response correctly', () async {
      final Map<String, dynamic> jsonMap = {
        "date": "2026-07-22",
        "egp": {
          "usd": 0.0,
        },
      };

      // act
      final result = CurrencyResponseModel.fromRemoteJson(jsonMap);

      // assert
      expect(result.date, "2026-07-22");

      final usdRate = result.rates['usd'];
      expect(usdRate, 0.0);
    });
  });
}
