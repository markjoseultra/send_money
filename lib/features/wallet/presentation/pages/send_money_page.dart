import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money/features/wallet/presentation/state/wallet_bloc.dart';
import 'package:send_money/features/wallet/presentation/widgets/error_bottom_sheet.dart';
import 'package:send_money/features/wallet/presentation/widgets/success_bottom_sheet.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<WalletBloc>().add(
      WalletSendMoney(
        senderId: 'senderId',
        recipientId: 'recipientId',
        amount: double.parse(_amountController.text),
        message: "Transaction message",
      ),
    );
  }

  void _showSuccessBottomSheet({
    String message = 'Your money has been sent successfully.',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SuccessBottomSheet(
            amountController: _amountController,
            message: message,
          ),
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
          'Send Money',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BlocListener<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletTransactionSuccess) {
                    _showSuccessBottomSheet();
                  } else if (state is WalletError) {
                    _showErrorBottomSheet(message: state.message);
                  }
                },
                child: SizedBox(),
              ),
              // Amount TextField
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount to send',
                  prefixText: '₱ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.indigo[700]!,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                ),
                style: TextStyle(fontSize: 18),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),

              SizedBox(height: 32),

              // Submit Button
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          state is WalletLoading ? null : _submitTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child:
                          state is WalletLoading
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Processing...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
