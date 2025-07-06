import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:send_money/core/platform/network_info.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_local_datasource.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:send_money/features/wallet/data/model/transaction_model.dart';
import 'package:send_money/features/wallet/data/repository/wallet_repository_impl.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockWalletRemoteDataSource extends Mock
    implements WalletRemoteDataSource {}

class MockWalletLocalDataSource extends Mock implements WalletLocalDatasource {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockWalletRemoteDataSource mockWalletRemoteDataSource;
  late MockWalletLocalDataSource mockWalletLocalDataSource;
  late WalletRepositoryImpl walletRepository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();

    mockWalletRemoteDataSource = MockWalletRemoteDataSource();

    mockWalletLocalDataSource = MockWalletLocalDataSource();

    walletRepository = WalletRepositoryImpl(
      remoteDataSource: mockWalletRemoteDataSource,
      networkInfo: mockNetworkInfo,
      localDataSource: mockWalletLocalDataSource,
    );
  });

  test("should trigger sendMoney with correct parameters", () async {
    final tEntity = TransactionModel(
      transactionId: "transactionId",
      sender: UserAccount(id: "id", name: "senderName"),
      recipient: UserAccount(id: "recipientId", name: "recipientName"),
      amount: 100,
      message: "Test message",
      timestamp: "1231231231231312",
      currency: "PHP",
      status: "completed",
    );

    when(
      () => mockWalletRemoteDataSource.sendMoney(
        senderId: "senderId",
        recipientId: "recipientId",
        amount: 100,
        message: "Test message",
      ),
    ).thenAnswer((_) async => Right(tEntity));

    final result = await walletRepository.sendMoney(
      senderId: "senderId",
      recipientId: "recipientId",
      amount: 100,
      message: "Test message",
    );

    verify(
      () => mockWalletRemoteDataSource.sendMoney(
        senderId: "senderId",
        recipientId: "recipientId",
        amount: 100,
        message: "Test message",
      ),
    ).called(1);

    expect(result, equals(Right(tEntity)));
  });

  test("Should return remote data if internet is online", () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

    when(
      () => mockWalletRemoteDataSource.getTransactions(),
    ).thenAnswer((_) async => Right([]));

    await walletRepository.getTransactions();

    verify(() => mockNetworkInfo.isConnected()).called(1);

    verify(() => mockWalletRemoteDataSource.getTransactions()).called(1);

    verifyNever(() => mockWalletLocalDataSource.getTransactions());
  });

  test("Should return local cache data if internet is offline", () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

    when(
      () => mockWalletLocalDataSource.getTransactions(),
    ).thenAnswer((_) async => []);

    await walletRepository.getTransactions();

    verify(() => mockNetworkInfo.isConnected()).called(1);

    verifyNever(() => mockWalletRemoteDataSource.getTransactions());

    verify(() => mockWalletLocalDataSource.getTransactions()).called(1);
  });

  test("Should return local cache data if internet is offline", () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

    when(
      () => mockWalletLocalDataSource.getTransactions(),
    ).thenAnswer((_) async => []);

    await walletRepository.getTransactions();

    verify(() => mockNetworkInfo.isConnected()).called(1);

    verifyNever(() => mockWalletRemoteDataSource.getTransactions());

    verify(() => mockWalletLocalDataSource.getTransactions()).called(1);
  });
}
