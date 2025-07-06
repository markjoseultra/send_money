import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:send_money/features/wallet/data/model/transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<Either<Exception, TransactionModel>> sendMoney({
    required String senderId,
    required String recipientId,
    required double amount,
    required String message,
  });

  Future<Either<Exception, List<TransactionModel>>> getTransactions();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Exception, TransactionModel>> sendMoney({
    required String senderId,
    required String recipientId,
    required double amount,
    required String message,
  }) async {
    try {
      final response = await dio.get(
        'https://fakeapi94.s3.ap-southeast-1.amazonaws.com/transaction.json',
        data: {
          'sender': senderId,
          'recipient': recipientId,
          'amount': amount,
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        final transactionData = response.data;
        final transactionEntity = TransactionModel.fromJson(transactionData);

        return Right(transactionEntity);
      } else {
        return Left(
          Exception('Failed to send money status code: ${response.statusCode}'),
        );
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<TransactionModel>>> getTransactions() async {
    try {
      final response = await dio.get(
        'https://fakeapi94.s3.ap-southeast-1.amazonaws.com/transactions.json',
      );
      if (response.statusCode == 200) {
        final List<dynamic> transactionsData = response.data;
        final List<TransactionModel> transactions =
            transactionsData
                .map((transaction) => TransactionModel.fromJson(transaction))
                .toList();

        return Right(transactions);
      } else {
        return Left(
          Exception(
            'Failed to fetch transactions status code: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
