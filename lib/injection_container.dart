import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:send_money/core/platform/network_info.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_local_datasource.dart';
import 'package:send_money/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:send_money/features/wallet/data/repository/wallet_repository_impl.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';
import 'package:send_money/features/wallet/presentation/state/transactions_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future init() async {
  sl.registerFactory(() => WalletBloc(sl()));

  sl.registerFactory(() => TransactionsBloc(sl()));

  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<WalletLocalDatasource>(
    () => WalletLocalDatasourceImpl(sharedPreferences: sl()),
  );

  //External

  sl.registerLazySingleton<Dio>(() => Dio());

  final sp = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sp);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}
