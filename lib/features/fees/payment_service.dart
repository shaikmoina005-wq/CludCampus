import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../core/constants/app_colors.dart';

const razorpayKeyId = String.fromEnvironment('RAZORPAY_KEY_ID');

class PaymentOutcome {
  const PaymentOutcome.success(this.paymentId, this.method, this.isTest)
      : ok = true,
        error = null;
  const PaymentOutcome.failure(this.error)
      : ok = false,
        paymentId = null,
        method = null,
        isTest = true;
  final bool ok;
  final String? paymentId;
  final String? method;
  final String? error;
  final bool isTest;
}

/// Opens Razorpay checkout when a key is configured, otherwise a simulated
/// "Test payment" sheet.
Future<PaymentOutcome?> startPayment(
  BuildContext context, {
  required double amount,
  required String description,
}) {
  if (razorpayKeyId.isEmpty) {
    return showModalBottomSheet<PaymentOutcome>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _TestCheckoutSheet(amount: amount, description: description),
    );
  }
  final completer = Completer<PaymentOutcome?>();
  final rp = Razorpay();
  void done(PaymentOutcome? o) {
    if (!completer.isCompleted) completer.complete(o);
    rp.clear();
  }

  rp.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
    done(PaymentOutcome.success(r.paymentId ?? 'unknown', 'Razorpay', true));
  });
  rp.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
    if (r.code == Razorpay.PAYMENT_CANCELLED) {
      done(null);
    } else {
      done(PaymentOutcome.failure(r.message ?? 'Payment failed'));
    }
  });
  rp.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse r) {
    done(PaymentOutcome.success(
        'wallet_${DateTime.now().millisecondsSinceEpoch}',
        r.walletName ?? 'Wallet',
        true));
  });
  try {
    rp.open({
      'key': razorpayKeyId,
      'amount': (amount * 100).round(),
      'currency': 'INR',
      'name': 'CludCampus',
      'description': description,
      'theme': {'color': '#2878C0'},
    });
  } catch (e) {
    done(PaymentOutcome.failure('Could not open checkout: $e'));
  }
  return completer.future;
}

class _TestCheckoutSheet extends StatefulWidget {
  const _TestCheckoutSheet({required this.amount, required this.description});
  final double amount;
  final String description;
  @override
  State<_TestCheckoutSheet> createState() => _TestCheckoutSheetState();
}

class _TestCheckoutSheetState extends State<_TestCheckoutSheet> {
  String method = 'UPI';
  static const methods = {
    'UPI': Icons.qr_code_2_rounded,
    'Card': Icons.credit_card_rounded,
    'Netbanking': Icons.account_balance_rounded,
  };

  String _fakeId() {
    const c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return 'pay_TEST${List.generate(10, (_) => c[r.nextInt(c.length)]).join()}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('TEST PAYMENT · no real money',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning)),
              ),
            ]),
            const SizedBox(height: 12),
            Text(widget.description, style: GoogleFonts.inter(color: muted)),
            Text(fmt.format(widget.amount),
                style: GoogleFonts.inter(
                    fontSize: 28, fontWeight: FontWeight.w700, color: navy)),
            const SizedBox(height: 12),
            for (final e in methods.entries)
              Card(
                elevation: 0,
                color: method == e.key
                    ? AppColors.brandBlue.withValues(alpha: 0.12)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: method == e.key
                          ? AppColors.brandBlue
                          : (isDark ? AppColors.darkBorder : AppColors.border)),
                ),
                child: ListTile(
                  leading: Icon(e.value, color: AppColors.brandBlue),
                  title: Text(e.key,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, color: navy)),
                  trailing: method == e.key
                      ? const Icon(Icons.check_circle, color: AppColors.brandBlue)
                      : null,
                  onTap: () => setState(() => method = e.key),
                ),
              ),
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  minimumSize: const Size.fromHeight(48)),
              onPressed: () => Navigator.pop(
                  context, PaymentOutcome.success(_fakeId(), method, true)),
              child: const Text('Simulate success'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(48)),
              onPressed: () => Navigator.pop(context,
                  const PaymentOutcome.failure('Bank declined the test payment')),
              child: const Text('Simulate failure'),
            ),
          ],
        ),
      ),
    );
  }
}
