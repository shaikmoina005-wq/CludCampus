import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/soft_card.dart';
import 'fee_payments_controller.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.record});
  final PaymentRecord record;

  String _text(NumberFormat fmt, DateFormat df) => [
        'CludCampus fee receipt${record.isTest ? ' (TEST)' : ''}',
        'Payment ID: ${record.paymentId}',
        'For: ${record.description}',
        'Amount: ${fmt.format(record.amount)}',
        'Date: ${df.format(record.paidAt)}',
        'Method: ${record.method}',
      ].join('\n');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final df = DateFormat('d MMM yyyy, h:mm a');
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 96,
                  child: Text(k, style: GoogleFonts.inter(color: muted))),
              Expanded(
                  child: SelectableText(v,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, color: navy))),
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 72, color: AppColors.success),
          const SizedBox(height: 8),
          Text('Payment successful',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w700, color: navy)),
          Text(fmt.format(record.amount),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandBlue)),
          if (record.isTest)
            Text('Test payment — no money was charged',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.warning)),
          const SizedBox(height: 18),
          SoftCard(
            accentLeft: true,
            child: Column(children: [
              row('Payment ID', record.paymentId),
              row('For', record.description),
              row('Amount', fmt.format(record.amount)),
              row('Date', df.format(record.paidAt)),
              row('Method', record.method),
            ]),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                minimumSize: const Size.fromHeight(48)),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _text(fmt, df)));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Receipt copied — paste it in WhatsApp or email')));
              }
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy receipt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Fees'),
          ),
        ],
      ),
    );
  }
}
