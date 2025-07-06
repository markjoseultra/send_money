import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@Freezed()
@JsonSerializable()
class Transaction with _$Transaction {
  @override
  final String status;
  @override
  final String transactionId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final UserAccount sender;
  @override
  final UserAccount recipient;
  @override
  final String timestamp;
  @override
  final String message;

  const Transaction({
    required this.status,
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.sender,
    required this.recipient,
    required this.timestamp,
    required this.message,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, Object?> toJson() => _$TransactionToJson(this);
}
