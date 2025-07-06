import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money/features/wallet/presentation/pages/send_money_page.dart';
import 'package:send_money/features/wallet/presentation/pages/transactions_page.dart';
import 'package:send_money/features/wallet/presentation/state/transactions_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';
import 'package:send_money/features/wallet/presentation/widgets/error_bottom_sheet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  bool _isBalanceVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    context.read<WalletBloc>().add(WalletStarted());
    context.read<TransactionsBloc>().add(TransactionsStarted());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _sendMoney() {
    // Navigate to send money screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SendMoneyPage()),
    );
  }

  void _viewTransactions() {
    // Navigate to transactions screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionsPage()),
    );
  }

  void _showErrorBottomSheet({
    String message = 'Something went wrong. Please try again.',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ErrorBottomSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocListener<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletError) {
                    _showErrorBottomSheet(message: state.message);
                  }
                },
                child: SizedBox(),
              ),
              // Header with gradient background
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (
                              Widget child,
                              Animation<double> animation,
                            ) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Semantics(
                              label: 'Wallet Balance',
                              child: Text(
                                _isBalanceVisible
                                    ? '₱${context.watch<WalletBloc>().state.balance.toStringAsFixed(2)}'
                                    : '₱••••••',
                                key: ValueKey<bool>(_isBalanceVisible),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Semantics(
                            label: "Toggle Balance Visibility",
                            child: GestureDetector(
                              onTap: _toggleBalanceVisibility,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  _isBalanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Main Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Send Money Button
                    Semantics(
                      label: 'Send Money',
                      child: _buildActionButton(
                        title: 'Send Money',
                        subtitle: 'Transfer funds to anyone',
                        icon: Icons.send,
                        color: Colors.blue,
                        onPressed: _sendMoney,
                      ),
                    ),

                    SizedBox(height: 16),

                    // View Transactions Button
                    Semantics(
                      label: 'View Transactions',
                      child: _buildActionButton(
                        title: 'View Transactions',
                        subtitle: 'Check your transaction history',
                        icon: Icons.history,
                        color: Colors.green,
                        onPressed: _viewTransactions,
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
