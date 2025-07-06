import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_remote_datasource.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  MockDioClient mockDioClient;

  group("wallet_remote_datasource_test", () {
    test("should send money successfully", () {
      // Arrange
      // Mock the remote datasource and repository
      mockDioClient = MockDioClient();

      final walletRemoteDataSourceImpl = WalletRemoteDataSourceImpl(
        dio: mockDioClient,
      );

      // Act
      // Call the sendMoney method
      walletRemoteDataSourceImpl.sendMoney(
        senderId: "senderId",
        recipientId: "recipientId",
        amount: 100,
        message: "Test message",
      );

      // Assert
      // Verify that the transaction was created successfully
      verify(
        () => mockDioClient.get(
          'https://fakeapi94.s3.ap-southeast-1.amazonaws.com/transaction.json',
          data: {
            'sender': 'senderId',
            'recipient': 'recipientId',
            'amount': 100,
            'message': 'Test message',
          },
        ),
      ).called(1);
    });
  });
}
