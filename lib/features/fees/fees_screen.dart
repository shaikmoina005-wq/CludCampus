import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/models.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';
import '../auth/auth_controller.dart';
import 'fee_payments_controller.dart';
import 'payment_service.dart';
import 'receipt_screen.dart';

Future<void> payFees(BuildContext context, WidgetRef ref, List<FeeItem> items) async {
  if (items.isEmpty) return;
  final amount = items.fold<double>(0, (s, f) => s + f.amount);
  final desc = items.length == 1
      ? '${items.first.title} fee'
      : 'All dues (${items.map((f) => f.title).join(', ')})';
  final outcome = await startPayment(context, amount: amount, description: desc);
  if (!context.mounted || outcome == null) return;
  if (!outcome.ok) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.danger,
      content: Text('Payment failed: ${outcome.error}. Please try again.'),
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.white,
        onPressed: () => payFees(context, ref, items),
      ),
    ));
    return;
  }
  final record = PaymentRecord(
    paymentId: outcome.paymentId!,
    feeIds: [for (final f in items) f.id],
    description: desc,
    amount: amount,
    method: outcome.method!,
    paidAt: DateTime.now(),
    isTest: outcome.isTest,
  );
  ref.read(feePaymentsProvider.notifier).markPaid(record);
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ReceiptScreen(record: record)),
  );
}

class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(feePaymentsProvider);
    final fees = st.fees;
    final pending = st.pending;
    final pendingTotal = st.pendingTotal;
    final df = DateFormat('d MMM yyyy');
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final canPay = ref.watch(authControllerProvider).role.isStudent;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(title: 'CludCampus'),
            PageTitleBlock(
              title: 'Fees',
              subtitle: canPay
                  ? 'Academic year 2026–27'
                  : 'Student dues and receipts',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    accentLeft: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance due',
                          style: GoogleFonts.inter(color: muted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          fmt.format(pendingTotal),
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (pending.isEmpty)
                          Text('All fees paid 🎉',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success))
                        else if (canPay)
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.brandBlue,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(46),
                            ),
                            onPressed: () => payFees(context, ref, pending),
                            icon: const Icon(Icons.lock_rounded, size: 18),
                            label: Text('Pay total ${fmt.format(pendingTotal)}'),
                          )
                        else
                          Text(
                            'Student dues on file. Payment stays with the student.',
                            style: GoogleFonts.inter(fontSize: 13, color: muted),
                          ),
                        if (canPay && razorpayKeyId.isEmpty) ...[
                          const SizedBox(height: 6),
                          Text('Demo mode — payments are simulated',
                              style: GoogleFonts.inter(fontSize: 11, color: muted)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final item in fees)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FeeRow(
                        item: item,
                        fmt: fmt,
                        navy: navy,
                        muted: muted,
                        canPay: canPay,
                        onPay: () => payFees(context, ref, [item]),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text('Payment history',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w700, color: navy)),
                  const SizedBox(height: 8),
                  if (st.history.isEmpty)
                    Text('No payments made in the app yet.',
                        style: GoogleFonts.inter(color: muted))
                  else
                    for (final r in st.history)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SoftCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => ReceiptScreen(record: r)),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.receipt_long_rounded,
                                color: AppColors.brandBlue),
                            title: Text(r.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600, color: navy)),
                            subtitle: Text(
                                '${df.format(r.paidAt)} · ${r.method}',
                                style: GoogleFonts.inter(color: muted)),
                            trailing: Text(fmt.format(r.amount),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success)),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({
    required this.item,
    required this.fmt,
    required this.navy,
    required this.muted,
    required this.canPay,
    required this.onPay,
  });
  final VoidCallback onPay;
  final FeeItem item;
  final NumberFormat fmt;
  final Color navy;
  final Color muted;
  final bool canPay;

  @override
  Widget build(BuildContext context) {
    final paid = item.status == 'paid';
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paid
                      ? fmt.format(item.amount)
                      : '${fmt.format(item.amount)} · due ${DateFormat('d MMM').format(item.dueDate)}',
                  style: GoogleFonts.inter(color: muted),
                ),
              ],
            ),
          ),
          if (paid)
            Text(
              'Paid',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            )
          else if (!canPay)
            Text(
              'Due',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            )
          else
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onPay,
              child: const Text('Pay now'),
            ),
        ],
      ),
    );
  }
}
