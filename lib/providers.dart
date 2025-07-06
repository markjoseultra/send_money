import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/transactions_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';
import 'package:send_money/injection_container.dart';

List<BlocProvider> providers = [
  BlocProvider<WalletBloc>(create: (context) => sl<WalletBloc>()),
  BlocProvider<TransactionsBloc>(create: (context) => sl<TransactionsBloc>()),
];
