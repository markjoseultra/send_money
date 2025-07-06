import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_local_datasource.dart';
import 'package:send_money/features/wallet/data/model/transaction_model.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late WalletLocalDatasourceImpl walletLocalDatasourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    walletLocalDatasourceImpl = WalletLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("WalletLocalDatasourceImpl unit tests", () {
    test("getWalletBalance should return the correct value", () async {
      when(
        () => mockSharedPreferences.getDouble("WALLET_BALANCE"),
      ).thenAnswer((_) => 200.0);

      final result = await walletLocalDatasourceImpl.getWalletBalance();

      expect(result, equals(Right(200.0)));
    });

    test("updateWalletBalance should return the new value", () async {
      when(
        () => mockSharedPreferences.setDouble('WALLET_BALANCE', 200.0),
      ).thenAnswer((_) async => true);

      when(
        () => mockSharedPreferences.getDouble("WALLET_BALANCE"),
      ).thenAnswer((_) => 200.0);

      final result = await walletLocalDatasourceImpl.updatedWalletBalance(
        balance: 200.0,
      );

      expect(result, equals(Right(200.0)));
    });

    test(
      "getTransactions should return empty [] if no cache is available",
      () async {
        when(
          () => mockSharedPreferences.getStringList('TRANSACTIONS'),
        ).thenAnswer((_) => []);

        final result = await walletLocalDatasourceImpl.getTransactions();

        expect(result, []);
      },
    );

    test("getTransactions should return cached transactions", () async {
      String data = fixtureReader('transaction.json');

      when(
        () => mockSharedPreferences.getStringList('TRANSACTIONS'),
      ).thenAnswer((_) => [data]);

      final result = await walletLocalDatasourceImpl.getTransactions();

      expect(result, [
        TransactionModel(
          status: "success",
          transactionId: "txn_1a2b3c4d5e6f7g8h",
          amount: 150.0,
          currency: "PHP",
          sender: UserAccount(id: "user_12345", name: "John Smith"),
          recipient: UserAccount(id: "user_67890", name: "Sarah Johnson"),
          timestamp: "1751788446911",
          message: "Money sent successfully",
        ),
      ]);
    });

    tearDown(() {
      reset(mockSharedPreferences);
    });
  });
}
