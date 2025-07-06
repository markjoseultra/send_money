import 'package:fpdart/fpdart.dart';
import 'package:send_money/core/platform/network_info.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_local_datasource.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final NetworkInfo networkInfo;
  final WalletRemoteDataSource remoteDataSource;
  final WalletLocalDatasource localDataSource;

  WalletRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Exception, Transaction>> sendMoney({
    required String senderId,
    required String recipientId,
    required double amount,
    required String message,
  }) async {
    final result = await remoteDataSource.sendMoney(
      senderId: senderId,
      recipientId: recipientId,
      amount: amount,
      message: message,
    );

    return result.fold((e) => Left(e), (transaction) => Right(transaction));
  }

  @override
  Future<Either<Exception, double>> getWalletBalance() async {
    bool isConnected = await networkInfo.isConnected();

    if (isConnected) {
      final result = await localDataSource.getWalletBalance();
      return result.fold(
        (e) {
          return Left(e);
        },
        (balance) {
          return Right(balance);
        },
      );
    } else {
      return Left(Exception("No internet connection"));
    }
  }

  @override
  Future<Either<Exception, List<Transaction>>> getTransactions() async {
    bool isConnected = await networkInfo.isConnected();

    if (isConnected) {
      final result = await remoteDataSource.getTransactions();

      return result.fold(
        (e) {
          return Left(e);
        },
        (transactions) {
          return Right(transactions);
        },
      );
    } else {
      final result = await localDataSource.getTransactions();

      return Right(result);
    }
  }
}
