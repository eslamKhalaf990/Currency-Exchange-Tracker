import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_exchange_tracker/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
      'should forward the call to Connectivity.checkConnectivity',
      () async {
        // arrange
        final tConnectivityResult = [ConnectivityResult.wifi];
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => tConnectivityResult);

        // act
        await networkInfo.isConnected;

        // assert
        verify(() => mockConnectivity.checkConnectivity());
      },
    );

    test(
      'should return true when the call to Connectivity.checkConnectivity contains wifi',
      () async {
        // arrange
        final tConnectivityResult = [ConnectivityResult.wifi];
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => tConnectivityResult);

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, true);
      },
    );

    test(
      'should return true when the call to Connectivity.checkConnectivity contains mobile',
      () async {
        // arrange
        final tConnectivityResult = [ConnectivityResult.mobile];
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => tConnectivityResult);

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, true);
      },
    );

    test(
      'should return false when the call to Connectivity.checkConnectivity contains none',
      () async {
        // arrange
        final tConnectivityResult = [ConnectivityResult.none];
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => tConnectivityResult);

        // act
        final result = await networkInfo.isConnected;

        // assert
        expect(result, false);
      },
    );
  });
}
