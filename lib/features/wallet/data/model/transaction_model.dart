import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.status,
    required super.transactionId,
    required super.amount,
    required super.currency,
    required super.sender,
    required super.recipient,
    required super.timestamp,
    required super.message,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      status: json['status'] ?? "",
      transactionId: json['transaction_id'] ?? "",
      amount: json['amount'] ?? 0.0,
      currency: json['currency'] ?? "",
      sender: UserAccount.fromJson(json['sender']),
      recipient: UserAccount.fromJson(json['recipient']),
      timestamp: json['timestamp'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
