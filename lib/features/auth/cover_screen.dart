import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/widgets/brand_wordmark.dart';
import '../../core/widgets/soft_card.dart';
import '../../core/widgets/wash_background.dart';
import 'auth_controller.dart';

class CoverScreen extends ConsumerStatefulWidget {
  const CoverScreen({super.key});

  @override
  ConsumerState<CoverScreen> createState() => _CoverScreenState();
}

class _CoverScreenState extends ConsumerState<CoverScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CollegeInfo> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return MockData.colleges;
    return MockData.colleges.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.city.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.abbrev.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _select(CollegeInfo college) async {
    await ref.read(authControllerProvider.notifier).selectCollege(college);
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final greeting = MockData.timeGreeting();

    return Scaffold(
      body: WashBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  children: [
                    const BrandWordmark(
                      logoSize: 44,
                      fontSize: 22,
                      centered: true,
                    ),
                    const SizedBox(height: 36),
                    Text(
                      greeting,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your complete college companion.\nSelect your college to continue.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search by name, city or code',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textFaint,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ..._filtered.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SoftCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          background: c.isLive
                              ? AppColors.liveHighlight
                              : Colors.white,
                          onTap: () => _select(c),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: c.isLive
                                      ? AppColors.brandBlue.withValues(
                                          alpha: 0.12,
                                        )
                                      : AppColors.elevated,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  c.abbrev,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: c.isLive
                                        ? AppColors.brandBlue
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: AppColors.navy,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textFaint,
                                        ),
                                        children: [
                                          TextSpan(text: '${c.code} · '),
                                          TextSpan(
                                            text: c.statusLabel,
                                            style: TextStyle(
                                              color: c.isLive
                                                  ? AppColors.attendanceGreen
                                                  : AppColors.textFaint,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textFaint,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get the app',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textFaint,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '·',
                        style: GoogleFonts.inter(
                          color: AppColors.textFaint,
                        ),
                      ),
                    ),
                    Text(
                      'Privacy',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
