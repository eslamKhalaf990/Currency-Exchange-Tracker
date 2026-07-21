import 'package:currency_exchange_tracker/core/error/exceptions.dart';
import 'package:currency_exchange_tracker/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late DioClient dioClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    // The DioClient constructor modifies dio options and adds interceptors
    // We need to stub these or ensure they don't crash
    when(() => mockDio.options).thenReturn(BaseOptions());
    when(() => mockDio.interceptors).thenReturn(Interceptors());
    
    dioClient = DioClient(mockDio);
  });

  group('DioClient Connection Timeout', () {

    // 1. test timeout
    test(
      'should throw NetworkException when Dio throws connectionTimeout',
      () async {
        // arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              onReceiveProgress: any(named: 'onReceiveProgress'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: 'test-url'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // act
        final call = dioClient.get('test-url');

        // assert
        expect(() => call, throwsA(isA<NetworkException>()));
      },
    );

    // 2. receive timeout
    test(
      'should throw NetworkException when Dio throws receiveTimeout',
      () async {
        // arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              onReceiveProgress: any(named: 'onReceiveProgress'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: 'test-url'),
            type: DioExceptionType.receiveTimeout,
          ),
        );

        // act
        final call = dioClient.get('test-url');

        // assert
        expect(() => call, throwsA(isA<NetworkException>()));
      },
    );

    // 3. connection error
     test(
      'should throw NetworkException when Dio throws connectionError',
      () async {
        // arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              onReceiveProgress: any(named: 'onReceiveProgress'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: 'test-url'),
            type: DioExceptionType.connectionError,
          ),
        );

        // act
        final call = dioClient.get('test-url');

        // assert
        expect(() => call, throwsA(isA<NetworkException>()));
      },
    );

    // 4. bad response 500 or 404 status code
     test(
      'should throw ServerException when Dio throws badResponse',
      () async {
        // arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              onReceiveProgress: any(named: 'onReceiveProgress'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: 'test-url'),
            type: DioExceptionType.badResponse,
          ),
        );

        // act
        final call = dioClient.get('test-url');

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
