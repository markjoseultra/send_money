import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:send_money/features/wallet/data/model/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalletLocalDatasource {
  Future<Either<Exception, double>> getWalletBalance();

  Future<Either<Exception, double>> updatedWalletBalance({
    required double balance,
  });

  Future<List<TransactionModel>> getTransactions();

  Future cacheTransactions(List<TransactionModel> transactions);
}

class WalletLocalDatasourceImpl implements WalletLocalDatasource {
  final SharedPreferences sharedPreferences;

  WalletLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Either<Exception, double>> getWalletBalance() async {
    try {
      final balance = sharedPreferences.getDouble('WALLET_BALANCE');
      if (balance == null) {
        await sharedPreferences.setDouble('WALLET_BALANCE', 500.0);

        return Future.value(Right(500.0));
      }

      return Future.value(Right(balance));
    } catch (e) {
      return Future.value(Left(Exception('Failed to get wallet balance')));
    }
  }

  @override
  Future<Either<Exception, double>> updatedWalletBalance({
    required double balance,
  }) async {
    try {
      await sharedPreferences.setDouble('WALLET_BALANCE', balance);

      final newbalance = sharedPreferences.getDouble('WALLET_BALANCE') ?? 0.0;

      return Future.value(Right(newbalance));
    } catch (e) {
      return Future.value(Left(Exception('Failed to get wallet balance')));
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final transactionsJson =
        sharedPreferences.getStringList('TRANSACTIONS') ?? [];

    if (transactionsJson.isEmpty) {
      return [];
    }

    final transactions =
        transactionsJson
            .map((json) => TransactionModel.fromJson(jsonDecode(json)))
            .toList();

    return transactions;
  }

  @override
  Future cacheTransactions(List<TransactionModel> transactions) {
    try {
      final transactionsJson =
          transactions.map((tx) => jsonEncode(tx.toJson())).toList();

      sharedPreferences.setStringList('TRANSACTIONS', transactionsJson);
      return Future.value(Right(null));
    } catch (e) {
      return Future.value(Left(Exception('Failed to cache transactions')));
    }
  }
}
