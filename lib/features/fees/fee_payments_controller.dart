import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';

class PaymentRecord {
  const PaymentRecord({
    required this.paymentId,
    required this.feeIds,
    required this.description,
    required this.amount,
    required this.method,
    required this.paidAt,
    required this.isTest,
  });
  final String paymentId;
  final List<String> feeIds;
  final String description;
  final double amount;
  final String method;
  final DateTime paidAt;
  final bool isTest;
}

class FeesState {
  const FeesState({required this.fees, required this.history});
  final List<FeeItem> fees;
  final List<PaymentRecord> history;

  List<FeeItem> get pending => fees.where((f) => f.status != 'paid').toList();
  double get pendingTotal => pending.fold(0, (s, f) => s + f.amount);
}

class FeePaymentsController extends Notifier<FeesState> {
  @override
  FeesState build() => FeesState(fees: List.of(MockData.fees), history: const []);

  void markPaid(PaymentRecord record) {
    state = FeesState(
      fees: [
        for (final f in state.fees)
          record.feeIds.contains(f.id)
              ? FeeItem(
                  id: f.id,
                  title: f.title,
                  amount: f.amount,
                  dueDate: f.dueDate,
                  status: 'paid',
                )
              : f,
      ],
      history: [record, ...state.history],
    );
  }
}

final feePaymentsProvider =
    NotifierProvider<FeePaymentsController, FeesState>(FeePaymentsController.new);
