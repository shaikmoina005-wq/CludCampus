import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/soft_card.dart';

class GetAppScreen extends StatelessWidget {
  const GetAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? AppColors.darkTextPrimary : AppColors.navy;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(title: 'CludCampus'),
            const PageTitleBlock(
              title: 'Get the app',
              subtitle: 'Home Screen, iPhone and Android',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Install CludCampus',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add the college companion to your phone home screen. Demo APKs are signed debug/release builds for Android.',
                          style: GoogleFonts.inter(color: muted, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SoftCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone_iphone, color: AppColors.brandBlue),
                      title: Text(
                        'iPhone',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: navy),
                      ),
                      subtitle: Text(
                        'Safari → Share → Add to Home Screen',
                        style: GoogleFonts.inter(color: muted),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SoftCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.android, color: AppColors.brandBlue),
                      title: Text(
                        'Android',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: navy),
                      ),
                      subtitle: Text(
                        'Chrome → menu → Install app, or sideload the APK',
                        style: GoogleFonts.inter(color: muted),
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
