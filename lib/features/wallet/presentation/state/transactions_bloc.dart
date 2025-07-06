import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final WalletRepository walletRepository;

  TransactionsBloc(this.walletRepository)
    : super(TransactionsInitial(transactions: [])) {
    on<TransactionsStarted>(_onTransactionsStarted);
  }

  void _onTransactionsStarted(TransactionsStarted event, emit) async {
    final transactionsResult = await walletRepository.getTransactions();

    transactionsResult.fold(
      (e) {
        emit(
          TransactionsError(
            transactions: state.transactions,
            message: e.toString(),
          ),
        );
      },
      (transactions) {
        emit(TransactionsLoaded(transactions: transactions));
      },
    );
  }
}
