import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads an SVG from `assets/icons` with optional color tinting.
class AppSvgIcon extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final Color? color;

  const AppSvgIcon({
    super.key,
    required this.name,
    this.width = 20,
    this.height = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final path = 'assets/icons/$name.svg';
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
      placeholderBuilder: (context) => SizedBox(width: width, height: height),
    );
  }
}
