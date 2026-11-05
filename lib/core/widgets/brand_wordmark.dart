import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Official CludCampus wordmark image (serif 3D mark from brand asset).
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.logoSize = 36,
    this.fontSize = 20,
    this.centered = false,
    this.showSubtitle,
    this.height,
  });

  /// Legacy: treated as approximate mark height when [height] is null.
  final double logoSize;

  /// Unused for image wordmark; kept so call sites compile.
  final double fontSize;
  final bool centered;
  final String? showSubtitle;

  /// Explicit image height; defaults to [logoSize] * 1.15 for the full wordmark.
  final double? height;

  static const assetPath = 'assets/branding/cludcampus-wordmark.png';

  @override
  Widget build(BuildContext context) {
    final h = height ?? (logoSize * 1.35);
    final image = Image.asset(
      assetPath,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'CludCampus',
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        image,
        if (showSubtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            showSubtitle!,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.faintTextOf(context),
            ),
          ),
        ],
      ],
    );

    if (centered) {
      return Center(child: column);
    }
    return column;
  }
}

/// Compact brand mark — same official wordmark, smaller.
class BrandLogoMark extends StatelessWidget {
  const BrandLogoMark({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      BrandWordmark.assetPath,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'CludCampus',
    );
  }
}
