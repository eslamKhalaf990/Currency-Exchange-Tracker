import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:currency_exchange_tracker/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnection mockInternetConnection;

  setUp(() {
    mockInternetConnection = MockInternetConnection();
    networkInfo = NetworkInfoImpl(mockInternetConnection);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnection.hasInternetAccess',
      () async {
        // arrange
        when(() => mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        // act
        await networkInfo.isConnected;

        // assert
        verify(() => mockInternetConnection.hasInternetAccess);
      },
    );

    test(
      'should return true when the call to InternetConnection.hasInternetAccess is true',
      () async {
        // arrange
        when(() => mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => true);

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, true);
      },
    );

    test(
      'should return false when the call to InternetConnection.hasInternetAccess is false',
      () async {
        // arrange
        when(() => mockInternetConnection.hasInternetAccess)
            .thenAnswer((_) async => false);

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, false);
      },
    );
  });
}
