import 'package:flutter/material.dart';

/// A person's name, wrapped onto as many lines as it needs.
/// Nothing here ellipsizes or keeps only the first word.
class FullNameText extends StatelessWidget {
  const FullNameText(
    this.name, {
    super.key,
    this.style,
    this.textAlign,
  });

  final String name;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: style,
      textAlign: textAlign,
      softWrap: true,
    );
  }
}
