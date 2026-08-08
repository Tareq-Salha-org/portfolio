import 'package:flutter/material.dart';

import '../utils/device.dart';

/// Wraps a section's content in the max-width container with consistent
/// horizontal/vertical padding. All sections use this for uniform spacing.
class ContentSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  const ContentSection({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final h = Responsive.sectionHPadding(context);
    final v = Responsive.sectionVPadding(context);
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.symmetric(horizontal: h, vertical: v),
      alignment: alignment,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.contentMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}
