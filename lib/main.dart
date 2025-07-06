import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money/features/wallet/presentation/pages/wallet_page.dart';
import 'package:send_money/injection_container.dart';
import 'package:send_money/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(home: WalletPage()),
    );
  }
}
