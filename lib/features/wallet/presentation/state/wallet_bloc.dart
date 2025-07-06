import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  WalletBloc(this.walletRepository) : super(WalletInitial(balance: 0.0)) {
    on<WalletStarted>(_onWalletStarted);
    on<WalletSendMoney>(_onSendMoney);
  }

  void _onWalletStarted(WalletStarted event, emit) async {
    emit(WalletLoading(balance: state.balance));

    final balanceResult = await walletRepository.getWalletBalance();

    balanceResult.fold(
      (e) {
        emit(WalletError(balance: state.balance, message: e.toString()));
      },
      (balance) {
        emit(WalletInitial(balance: balance));
      },
    );
  }

  void _onSendMoney(WalletSendMoney event, emit) async {
    final newBalance = state.balance - event.amount;

    emit(WalletLoading(balance: state.balance));

    if (newBalance < 0) {
      // Handle insufficient balance case, e.g., show an error message
      emit(
        WalletError(balance: state.balance, message: 'Insufficient balance'),
      );

      return;
    }

    final sendResult = await walletRepository.sendMoney(
      recipientId: event.recipientId,
      amount: event.amount,
      senderId: event.senderId,
      message: event.message,
    );

    sendResult.fold(
      (e) {
        emit(WalletError(balance: state.balance, message: e.toString()));
      },
      (success) {
        // Handle success case, e.g., update balance or show a success message
        emit(WalletTransactionSuccess(balance: newBalance));
      },
    );
  }
}
