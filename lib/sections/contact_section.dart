import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/services/contact_service.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;
    final palette = AppPalette.of(context);

    return ContentSection(
      child: Stack(
        children: [
          // Soft ending glow behind the whole section.
          PositionedDirectional(
            bottom: -160,
            end: -120,
            child: GlowBackdrop(
              color: palette.primary,
              opacity: 0.14,
              size: 460,
            ),
          ),
          StaggeredGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggeredItem(
                  index: 0,
                  child: SectionHeader(
                    eyebrow: strings.eyebrowContact,
                    title: strings.contactTitle,
                    subtitle: strings.contactSubtitle,
                  ),
                ),
                const SizedBox(height: 48),
                Responsive.isMobile(context)
                    ? Column(
                        children: [
                          _buildInfo(context),
                          const SizedBox(height: 28),
                          const StaggeredItem(index: 6, child: _FormCard()),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _buildInfo(context)),
                          const SizedBox(width: 40),
                          const Expanded(
                            flex: 6,
                            child: StaggeredItem(index: 6, child: _FormCard()),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final items = <_ContactLink>[
      _ContactLink(
        icon: Icons.email_outlined,
        label: 'Email',
        value: PortfolioData.email,
        url: AppLinks.mailto(PortfolioData.email),
        external: true,
      ),
      _ContactLink(
        icon: Icons.phone_outlined,
        label: 'Phone',
        value: PortfolioData.phone,
        url: 'tel:${PortfolioData.phone}',
        external: true,
      ),
      _ContactLink(
        icon: Icons.location_on_outlined,
        label: 'Location',
        value: PortfolioData.location,
      ),
      _ContactLink(
        icon: Icons.code,
        svg: 'github',
        label: 'GitHub',
        value: PortfolioData.githubHandle,
        url: PortfolioData.github,
        external: true,
      ),
      _ContactLink(
        icon: Icons.link,
        label: 'LinkedIn',
        value: 'LinkedIn',
        url: PortfolioData.linkedIn,
        external: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          StaggeredItem(
            index: i + 1,
            offset: 22,
            child: _ContactLinkCard(item: items[i]),
          ),
        ],
      ],
    );
  }
}

class _FormCard extends StatefulWidget {
  const _FormCard();

  @override
  State<_FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<_FormCard> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  bool _sending = false;
  bool _sent = false;
  bool _failed = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _sending = true;
      _failed = false;
    });

    final result = await ContactService.submit(
      name: _name.text.trim(),
      email: _email.text.trim(),
      message: _message.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = result.success;
      _failed = !result.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.primary, palette.accent],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(scope.strings.formTitle, style: styles.titleLarge),
          const SizedBox(height: 6),
          Text(
            scope.strings.formHint,
            style: styles.bodySmall.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: 24),
          AnimatedSize(
            duration: AppDurations.normal,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _sent ? _buildSuccess(context) : _buildForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: palette.success.withValues(alpha: 0.14),
            shape: BoxShape.circle,
            border: Border.all(color: palette.success.withValues(alpha: 0.4)),
          ),
          child: Icon(Icons.check_rounded, size: 32, color: palette.success),
        ),
        const SizedBox(height: 18),
        Text(scope.strings.formSuccessTitle, style: styles.titleLarge),
        const SizedBox(height: 8),
        Text(
          scope.strings.formSuccessBody,
          textAlign: TextAlign.center,
          style: styles.bodySmall.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: 22),
        AppButton(
          label: scope.strings.formSendAnother,
          icon: Icons.edit_outlined,
          variant: AppButtonVariant.secondary,
          expanded: true,
          onTap: _reset,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final scope = AppScope.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildField(
            context,
            controller: _name,
            label: scope.strings.formFieldName,
            hint: scope.strings.formFieldNameHint,
            kind: _FieldKind.name,
          ),
          const SizedBox(height: 18),
          _buildField(
            context,
            controller: _email,
            label: scope.strings.formFieldEmail,
            hint: 'you@email.com',
            kind: _FieldKind.email,
          ),
          const SizedBox(height: 18),
          _buildField(
            context,
            controller: _message,
            label: scope.strings.formFieldMessage,
            hint: scope.strings.formFieldMessageHint,
            kind: _FieldKind.message,
          ),
          if (_failed) ...[
            const SizedBox(height: 18),
            _buildError(context),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: _sending
                ? scope.strings.formSending
                : scope.strings.formSubmit,
            icon: Icons.send_rounded,
            expanded: true,
            loading: _sending,
            onTap: _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, size: 20, color: palette.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scope.strings.formErrorTitle,
                  style: styles.labelMedium.copyWith(color: palette.error),
                ),
                const SizedBox(height: 3),
                Text(
                  scope.strings.formErrorBody,
                  style: styles.caption.copyWith(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _reset() {
    if (_sending) return;
    _formKey.currentState?.reset();
    _name.clear();
    _email.clear();
    _message.clear();
    setState(() {
      _sent = false;
      _failed = false;
    });
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required _FieldKind kind,
  }) {
    final styles = AppTextStyles.of(context);
    final scope = AppScope.of(context);

    String? validateField(String? value) {
      final v = (value ?? '').trim();
      if (v.isEmpty) {
        return scope.strings.formErrorEmpty;
      }
      if (kind == _FieldKind.email &&
          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
        return scope.strings.formErrorEmail;
      }
      return null;
    }

    final isMessage = kind == _FieldKind.message;
    final isEmail = kind == _FieldKind.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: styles.labelMedium.copyWith(
            color: AppPalette.of(context).textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMessage ? 5 : 1,
          validator: validateField,
          style: AppTextStyles.build(
            context,
            15,
            FontWeight.w400,
            color: AppPalette.of(context).textPrimary,
          ),
          decoration: InputDecoration(hintText: hint),
          textInputAction: isMessage
              ? TextInputAction.newline
              : TextInputAction.next,
          keyboardType: isMessage
              ? TextInputType.multiline
              : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        ),
      ],
    );
  }
}

enum _FieldKind { name, email, message }

class _ContactLink {
  final IconData icon;
  final String? svg;
  final String label;
  final String value;
  final String? url;
  final bool external;

  const _ContactLink({
    required this.icon,
    this.svg,
    required this.label,
    required this.value,
    this.url,
    this.external = false,
  });
}

class _ContactLinkCard extends StatelessWidget {
  final _ContactLink item;

  const _ContactLinkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final styles = AppTextStyles.of(context);

    Widget card = HoverCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: item.svg != null
                ? AppSvgIcon(
                    name: item.svg!,
                    width: 21,
                    height: 21,
                    color: palette.primary,
                  )
                : Icon(item.icon, size: 20, color: palette.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: styles.caption.copyWith(color: palette.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: styles.bodySmall.copyWith(color: palette.textPrimary),
                ),
              ],
            ),
          ),
          if (item.external)
            Icon(Icons.open_in_new, size: 15, color: palette.textMuted),
        ],
      ),
    );

    if (item.url != null) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => AppLinks.open(item.url!),
          child: card,
        ),
      );
    }
    return card;
  }
}
