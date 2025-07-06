part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState({required this.transactions});

  final List<Transaction> transactions;
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial({required super.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading({required super.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded({required super.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionsError extends TransactionsState {
  const TransactionsError({required super.transactions, required this.message});

  final String message;

  @override
  List<Object> get props => [transactions, message];
}
