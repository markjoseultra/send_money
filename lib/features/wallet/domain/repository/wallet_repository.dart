import 'package:fpdart/fpdart.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';

abstract class WalletRepository {
  Future<Either<Exception, Transaction>> sendMoney({
    required String senderId,
    required String recipientId,
    required double amount,
    required String message,
  });

  Future<Either<Exception, double>> getWalletBalance();

  Future<Either<Exception, List<Transaction>>> getTransactions();
}
