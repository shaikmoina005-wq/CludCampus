import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.onTap,
    this.accentLeft = false,
    this.background,
    this.borderRadius = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool accentLeft;
  final Color? background;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = background ??
        (isDark ? AppColors.darkSurface : AppColors.surface);
    final borderColor = AppColors.borderOf(context);
    final accent = AppColors.chromeAccentOf(context);
    final radius = BorderRadius.circular(borderRadius);
    final resolvedPadding = padding.resolve(TextDirection.ltr);
    final contentPadding = accentLeft
        ? resolvedPadding.copyWith(left: resolvedPadding.left + 4)
        : resolvedPadding;

    final styledChild = DefaultTextStyle(
      style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryTextOf(context),
          ) ??
          TextStyle(color: AppColors.primaryTextOf(context)),
      child: IconTheme(
        data: IconThemeData(color: AppColors.primaryTextOf(context)),
        child: child,
      ),
    );

    Widget inner = Stack(
      children: [
        if (accentLeft)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ColoredBox(
              color: accent,
              child: const SizedBox(width: 4),
            ),
          ),
        Padding(padding: contentPadding, child: styledChild),
      ],
    );

    if (onTap == null) {
      return Container(
        margin: margin,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: inner,
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: bg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: inner,
        ),
      ),
    );
  }
}
