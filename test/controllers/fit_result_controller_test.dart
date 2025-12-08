import 'package:dio/dio.dart';
import 'package:fittim_flutter/data/api_provider.dart';
import 'package:fittim_flutter/ui/pages/fit/result/fit_result_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fit_result_controller_test.mocks.dart';

@GenerateMocks([ApiProvider, Dio, FlutterSecureStorage])
void main() {
  late FitResultController controller;
  late MockApiProvider mockApiProvider;
  late MockDio mockDio;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockApiProvider = MockApiProvider();
    mockDio = MockDio();
    mockStorage = MockFlutterSecureStorage();

    // Setup ApiProvider to return mock Dio
    when(mockApiProvider.dio).thenReturn(mockDio);

    // Setup Storage to return a token
    when(
      mockStorage.read(key: 'accessToken'),
    ).thenAnswer((_) async => 'fake_token');
  });

  test('fetches fit details when reason is missing', () async {
    // Arrange
    controller = FitResultController(
      apiProvider: mockApiProvider,
      storage: mockStorage,
    );

    // Arguments representing a history item with missing reason
    final historyArgs = {
      'id': 123,
      'place': 'Campus',
      'reason': null, // Missing reason
      'top': {
        'id': 1,
        'category': 'TOP',
        'season': 'SPRING',
        'imageUrl': '/shirt.png',
        'createdAt': '2023-01-01T00:00:00.000',
        'user': {'id': 1, 'username': 'test'},
        'isFavorite': false,
      },
    };

    // Correct API Response
    final apiResponseData = {
      'id': 123,
      'place': 'Campus',
      'reason': 'This is the Full AI Reason',
      'top': {
        'id': 1,
        'category': 'TOP',
        'season': 'SPRING',
        'imageUrl': '/shirt.png',
        'createdAt': '2023-01-01T00:00:00.000',
        'user': {'id': 1, 'username': 'test'},
        'isFavorite': false,
      },
    };

    when(mockDio.get(any, options: anyNamed('options'))).thenAnswer(
      (_) async => Response(
        data: apiResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/fits/123'),
      ),
    );

    // Act
    controller.initData(historyArgs);

    // Verify
    // 1. Check if ID was parsed
    expect(controller.fitId.value, 123);

    // 2. Wait for async if needed (controller methods are async but initData is void)
    // _fetchFitDetail is private and async, called without await.
    // We need to wait a bit for microtasks or check execution.
    // Since we can't await void method, we loop or use pump?
    // In unit test, we might need a small delay.
    await Future.delayed(const Duration(milliseconds: 100));

    // 3. Verify Dio was called
    verify(
      mockDio.get(
        '${ApiProvider.baseUrl}/api/fits/123',
        options: anyNamed('options'),
      ),
    ).called(1);

    // 4. Verify Reason updated
    expect(controller.reason.value, 'This is the Full AI Reason');
  });

  test('does NOT fetch fit details when reason is present', () async {
    // Arrange
    controller = FitResultController(
      apiProvider: mockApiProvider,
      storage: mockStorage,
    );

    final historyArgs = {
      'id': 123,
      'reason': 'Already Existing Reason', // Reason present
      'top': {
        'id': 1,
        'category': 'TOP',
        'season': 'SPRING',
        'imageUrl': '/shirt.png',
      },
    };

    // Act
    controller.initData(historyArgs); // Provide everything

    await Future.delayed(const Duration(milliseconds: 50));

    // Verify
    verifyNever(mockDio.get(any, options: anyNamed('options')));
    expect(controller.reason.value, 'Already Existing Reason');
  });
}
