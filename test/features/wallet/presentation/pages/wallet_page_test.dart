import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:send_money/features/wallet/domain/repository/wallet_repository.dart';
import 'package:send_money/features/wallet/presentation/pages/wallet_page.dart';
import 'package:send_money/features/wallet/presentation/state/transactions_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  MockWalletRepository mockWalletRepository = MockWalletRepository();

  testWidgets("Send Money Page ensure all widgets are visible", (
    WidgetTester tester,
  ) async {
    when(
      () => mockWalletRepository.getWalletBalance(),
    ).thenAnswer((_) async => Right(100.0));
    when(
      () => mockWalletRepository.getTransactions(),
    ).thenAnswer((_) async => Right([]));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(
            create: (_) => WalletBloc(mockWalletRepository),
          ),
          BlocProvider<TransactionsBloc>(
            create: (_) => TransactionsBloc(mockWalletRepository),
          ),
        ],
        child: MaterialApp(home: WalletPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Toggle Balance Visibility'), findsOneWidget);

    expect(find.bySemanticsLabel('Send Money'), findsOneWidget);

    expect(find.bySemanticsLabel('View Transactions'), findsOneWidget);
  });
}
