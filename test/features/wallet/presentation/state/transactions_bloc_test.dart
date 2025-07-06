import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';
import 'package:send_money/features/wallet/presentation/state/transactions_bloc.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  MockWalletRepository mockWalletRepository = MockWalletRepository();

  blocTest(
    'emits [] when nothing is added',
    build: () => TransactionsBloc(mockWalletRepository),
    expect: () => [],
  );

  blocTest(
    'Should emit value from repository when TransactionsStarted is added',
    build: () => TransactionsBloc(mockWalletRepository),
    act: (bloc) {
      bloc.add(TransactionsStarted());

      when(() => mockWalletRepository.getTransactions()).thenAnswer(
        (_) async => const Right([
          Transaction(
            status: 'completed',
            amount: 50.0,
            sender: UserAccount(id: 'sender123', name: 'Sender Name'),
            recipient: UserAccount(id: 'recipient123', name: 'Recipient Name'),
            message: 'Test transaction',
            timestamp: "1751788446911",
            currency: "PHP",
            transactionId: "txn_1a2b3c4d5e6f7g8p",
          ),
        ]),
      );
    },
    expect:
        () => [
          TransactionsLoaded(
            transactions: [
              Transaction(
                status: 'completed',
                amount: 50.0,
                sender: UserAccount(id: 'sender123', name: 'Sender Name'),
                recipient: UserAccount(
                  id: 'recipient123',
                  name: 'Recipient Name',
                ),
                message: 'Test transaction',
                timestamp: "1751788446911",
                currency: "PHP",
                transactionId: "txn_1a2b3c4d5e6f7g8p",
              ),
            ],
          ),
        ],
  );

  blocTest(
    'Should emit TransactionsError when TransactionsStarted is added and repository fails',
    build: () => TransactionsBloc(mockWalletRepository),
    act: (bloc) {
      bloc.add(TransactionsStarted());

      when(() => mockWalletRepository.getTransactions()).thenAnswer(
        (_) async => Left(Exception('Failed to fetch transactions')),
      );
    },
    expect:
        () => [
          TransactionsError(
            transactions: [],
            message: 'Exception: Failed to fetch transactions',
          ),
        ],
  );
}
