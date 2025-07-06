part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState({required this.balance});

  final double balance;
}

class WalletInitial extends WalletState {
  const WalletInitial({required super.balance});

  @override
  List<Object> get props => [balance];
}

class WalletLoading extends WalletState {
  const WalletLoading({required super.balance});

  @override
  List<Object> get props => [balance];
}

class WalletLoaded extends WalletState {
  const WalletLoaded({required super.balance});

  @override
  List<Object> get props => [balance];
}

class WalletTransactionSuccess extends WalletState {
  const WalletTransactionSuccess({required super.balance});

  @override
  List<Object> get props => [balance];
}

class WalletError extends WalletState {
  const WalletError({required super.balance, required this.message});

  final String message;

  @override
  List<Object> get props => [balance];
}
