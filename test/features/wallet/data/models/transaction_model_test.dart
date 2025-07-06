import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:send_money/features/wallet/data/model/transaction_model.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  test("TransactionModel toJson", () {
    final transactionModel = TransactionModel(
      status: 'success',
      transactionId: 'txn_1a2b3c4d5e6f7g8h',
      amount: 150.0,
      currency: 'PHP',
      sender: UserAccount(id: 'user_12345', name: 'John Smith'),
      recipient: UserAccount(id: 'user_67890', name: 'Sarah Johnson'),
      timestamp: '1751788446911',
      message: 'Money sent successfully',
    );

    final json = transactionModel.toJson();

    final expectedJson = {
      "status": "success",
      "transactionId": "txn_1a2b3c4d5e6f7g8h",
      "amount": 150.0,
      "currency": "PHP",
      'sender': UserAccount(id: 'user_12345', name: 'John Smith'),
      'recipient': UserAccount(id: 'user_67890', name: 'Sarah Johnson'),
      "timestamp": "1751788446911",
      "message": "Money sent successfully",
    };

    expect(json, expectedJson);
  });

  test("TransactionModel fromJson", () {
    String data = fixtureReader('transaction.json');

    final transactionModel = TransactionModel.fromJson(jsonDecode(data));

    expect(transactionModel.status, 'success');
    expect(transactionModel.transactionId, 'txn_1a2b3c4d5e6f7g8h');
    expect(transactionModel.amount, 150.0);
    expect(transactionModel.currency, 'PHP');
    expect(transactionModel.sender.id, 'user_12345');
    expect(transactionModel.sender.name, 'John Smith');
    expect(transactionModel.recipient.id, 'user_67890');
    expect(transactionModel.recipient.name, 'Sarah Johnson');
    expect(transactionModel.timestamp, '1751788446911');
    expect(transactionModel.message, 'Money sent successfully');
  });
}
