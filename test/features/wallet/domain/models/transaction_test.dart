import 'package:flutter_test/flutter_test.dart';
import 'package:send_money/features/wallet/domain/entities/transaction.dart';
import 'package:send_money/features/wallet/domain/entities/user_account.dart';

void main() {
  group("transaction model unit tests", () {
    test("should create a transaction", () {
      final transaction = Transaction(
        status: "success",
        transactionId: "12345",
        amount: 1000,
        currency: "USD",
        sender: UserAccount(id: "1", name: "Alice"),
        recipient: UserAccount(id: "2", name: "Bob"),
        timestamp: "1751785493088",
        message: "Payment for services rendered",
      );

      expect(transaction.status, "success");
      expect(transaction.transactionId, "12345");
      expect(transaction.amount, 1000);
      expect(transaction.currency, "USD");
      expect(transaction.sender.id, "1");
      expect(transaction.sender.name, "Alice");
      expect(transaction.recipient.id, "2");
      expect(transaction.recipient.name, "Bob");
      expect(transaction.timestamp, "1751785493088");
      expect(transaction.message, "Payment for services rendered");
    });

    test("should convert transaction to JSON", () {
      final transaction = Transaction(
        status: "success",
        transactionId: "12345",
        amount: 1000,
        currency: "USD",
        sender: UserAccount(id: "1", name: "Alice"),
        recipient: UserAccount(id: "2", name: "Bob"),
        timestamp: "1751785493088",
        message: "Payment for services rendered",
      );

      final json = transaction.toJson();

      expect(json, {
        "status": "success",
        "transactionId": "12345",
        "amount": 1000,
        "currency": "USD",
        'sender': UserAccount(id: "1", name: "Alice"),
        'recipient': UserAccount(id: "2", name: "Bob"),
        "timestamp": "1751785493088",
        "message": "Payment for services rendered",
      });
    });

    test("should create a transaction from JSON", () {
      final json = {
        "status": "success",
        "transactionId": "12345",
        "amount": 1000,
        "currency": "USD",
        "sender": {"id": "1", "name": "Alice"},
        "recipient": {"id": "2", "name": "Bob"},
        "timestamp": "1751785493088",
        "message": "Payment for services rendered",
      };

      final transaction = Transaction.fromJson(json);

      expect(transaction.status, "success");
      expect(transaction.transactionId, "12345");
      expect(transaction.amount, 1000);
      expect(transaction.currency, "USD");
      expect(transaction.sender.id, "1");
      expect(transaction.sender.name, "Alice");
      expect(transaction.recipient.id, "2");
      expect(transaction.recipient.name, "Bob");
      expect(transaction.timestamp, "1751785493088");
      expect(transaction.message, "Payment for services rendered");
    });

    test("should handle empty transaction", () {
      final transaction = Transaction(
        status: "",
        transactionId: "",
        amount: 0,
        currency: "",
        sender: UserAccount(id: "", name: ""),
        recipient: UserAccount(id: "", name: ""),
        timestamp: "",
        message: "",
      );

      expect(transaction.status, "");
      expect(transaction.transactionId, "");
      expect(transaction.amount, 0);
      expect(transaction.currency, "");
      expect(transaction.sender.id, "");
      expect(transaction.sender.name, "");
      expect(transaction.recipient.id, "");
      expect(transaction.recipient.name, "");
      expect(transaction.timestamp, "");
      expect(transaction.message, "");
    });

    test("toString test", () {
      final transaction = Transaction(
        status: "success",
        transactionId: "12345",
        amount: 1000.0,
        currency: "USD",
        sender: UserAccount(id: "1", name: "Alice"),
        recipient: UserAccount(id: "2", name: "Bob"),
        timestamp: "1751785493088",
        message: "Payment for services rendered",
      );

      expect(
        transaction.toString(),
        "Transaction(status: success, transactionId: 12345, amount: 1000.0, currency: USD, sender: UserAccount(id: 1, name: Alice), recipient: UserAccount(id: 2, name: Bob), timestamp: 1751785493088, message: Payment for services rendered)",
      );
    });
  });
}
