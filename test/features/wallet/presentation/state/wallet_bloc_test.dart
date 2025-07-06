import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  MockWalletRepository mockWalletRepository = MockWalletRepository();

  blocTest(
    'emits [] when nothing is added',
    build: () => WalletBloc(mockWalletRepository),
    expect: () => [],
  );

  blocTest(
    'Should emit value from repository when WalletStarted is added',
    build: () => WalletBloc(mockWalletRepository),
    act: (bloc) {
      bloc.add(WalletStarted());

      when(
        () => mockWalletRepository.getWalletBalance(),
      ).thenAnswer((_) async => const Right(100.0));
    },
    expect: () => [WalletLoading(balance: 0.0), WalletInitial(balance: 100.0)],
  );

  blocTest(
    'Should emit WalletError when WalletSendMoney is added with insufficient balance',
    build: () => WalletBloc(mockWalletRepository),
    seed: () => WalletInitial(balance: 30.0),
    act: (bloc) {
      bloc.add(
        WalletSendMoney(
          senderId: 'sender123',
          recipientId: 'recipient123',
          amount: 50.0,
          message: 'Test message',
        ),
      );
    },
    expect:
        () => [
          WalletLoading(balance: 30.0),
          WalletError(balance: 30.0, message: 'Insufficient balance'),
        ],
  );

  blocTest(
    "Should emit WalletLoaded when WalletSendMoney is added with sufficient balance",
    build: () => WalletBloc(mockWalletRepository),
    seed: () => WalletInitial(balance: 30.0),
    act: (bloc) {
      bloc.add(
        WalletSendMoney(
          senderId: 'sender123',
          recipientId: 'recipient123',
          amount: 30.0,
          message: 'Test message',
        ),
      );

      when(
        () => mockWalletRepository.sendMoney(
          recipientId: 'recipient123',
          amount: 30.0,
          senderId: 'sender123',
          message: 'Test message',
        ),
      ).thenAnswer(
        (_) async => const Right(
          Transaction(
            status: 'completed',
            amount: 30.0,
            sender: UserAccount(id: 'sender123', name: 'Sender Name'),
            recipient: UserAccount(id: 'recipient123', name: 'Recipient Name'),
            message: 'Test message',
            timestamp: "1751788446911",
            currency: "PHP",
            transactionId: "txn_1a2b3c4d5e6f7g8p",
          ),
        ),
      );
    },
    expect:
        () => [
          WalletLoading(balance: 30.0),
          WalletTransactionSuccess(balance: 0.0),
        ],
  );
}
