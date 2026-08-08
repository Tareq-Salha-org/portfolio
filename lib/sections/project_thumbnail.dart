import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import 'project_visual.dart';

/// Displays a project's thumbnail image with a graceful fallback to
/// the abstract [ProjectVisual] if no image path is provided or if
/// the asset fails to load.
class ProjectThumbnail extends StatelessWidget {
  final String? imagePath;
  final List<String> techStack;
  final String primaryLanguage;
  final String projectName;
  final double height;
  final BorderRadius? borderRadius;

  const ProjectThumbnail({
    super.key,
    this.imagePath,
    required this.techStack,
    required this.primaryLanguage,
    required this.projectName,
    this.height = 200,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildFallback(context);
    }

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          imagePath!,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          semanticLabel: '$projectName project thumbnail',
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallback(context);
          },
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.codeBackground,
        borderRadius: borderRadius,
      ),
      child: ProjectVisual(
        techStack: techStack,
        primaryLanguage: primaryLanguage,
        accent: palette.primary,
      ),
    );
  }
}
