part of 'wallet_bloc.dart';

class WalletEvent {
  const WalletEvent();
}

class WalletStarted extends WalletEvent {
  const WalletStarted();
}

class WalletSendMoney extends WalletEvent {
  final String senderId;
  final String recipientId;
  final double amount;
  final String message;

  const WalletSendMoney({
    required this.senderId,
    required this.recipientId,
    required this.amount,
    required this.message,
  });
}
