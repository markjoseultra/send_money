// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  status: json['status'] as String,
  transactionId: json['transactionId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  sender: UserAccount.fromJson(json['sender'] as Map<String, dynamic>),
  recipient: UserAccount.fromJson(json['recipient'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'status': instance.status,
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'timestamp': instance.timestamp,
      'message': instance.message,
    };
