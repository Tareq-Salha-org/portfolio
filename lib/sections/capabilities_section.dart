import 'package:flutter/material.dart';

import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/widgets/widgets.dart';

class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({super.key});

  static const List<_Capability> _items = [
    _Capability(
      Icons.cloud_outlined,
      'REST API Architecture',
      'Designing clean, predictable HTTP APIs with Laravel and PHP.',
    ),
    _Capability(
      Icons.storage_rounded,
      'Database Optimization',
      'Schema design, query tuning and caching strategies.',
    ),
    _Capability(
      Icons.cable_rounded,
      'Real-Time Communication',
      'WebSockets and live chat systems with reliable transports.',
    ),
    _Capability(
      Icons.extension_rounded,
      'Third-Party Integrations',
      'Voice APIs, e-invoicing and external service integrations.',
    ),
    _Capability(
      Icons.admin_panel_settings_outlined,
      'Role-Based Access Control',
      'Granular, secure permission models (RBAC).',
    ),
    _Capability(
      Icons.rocket_launch_rounded,
      'CI/CD Automation',
      'Automated testing and deployment pipelines.',
    ),
    _Capability(
      Icons.layers_outlined,
      'Scalable Systems',
      'Backends that grow with traffic without constant rewrites.',
    ),
    _Capability(
      Icons.architecture_rounded,
      'Clean API Design',
      'Consistent, predictable contracts easy for clients to consume.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowCapabilities,
            title: strings.capabilitiesTitle,
            subtitle: strings.capabilitiesSubtitle,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1100
                  ? 4
                  : width >= 680
                  ? 2
                  : 1;
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 150,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) =>
                    _CapabilityCard(item: _items[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Capability {
  final IconData icon;
  final String title;
  final String desc;

  const _Capability(this.icon, this.title, this.desc);
}

class _CapabilityCard extends StatelessWidget {
  final _Capability item;

  const _CapabilityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    return HoverCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 19, color: palette.primary),
          ),
          const SizedBox(height: 14),
          Text(item.title, style: styles.titleMedium),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styles.bodySmall.copyWith(color: palette.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
