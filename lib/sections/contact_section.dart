import 'package:flutter/material.dart';

import '../core/data/portfolio_data.dart';
import '../core/localization/app_scope.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../core/widgets/widgets.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);

    final subject = 'Portfolio inquiry — ${_name.text.trim()}';
    final body =
        'Hi Tareq,\n\n${_message.text.trim()}\n\n— ${_name.text.trim()} (${_email.text.trim()})';
    final url = AppLinks.mailto(
      PortfolioData.email,
      subject: subject,
      body: body,
    );

    await AppLinks.open(url);

    if (!mounted) return;
    setState(() => _sending = false);
    final scope = AppScope.read(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          scope.ar
              ? 'تم فتح تطبيق البريد لإرسال رسالتك.'
              : 'Your email client was opened to send the message.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = scope.strings;

    return ContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: strings.eyebrowContact,
            title: strings.contactTitle,
            subtitle: strings.contactSubtitle,
          ),
          const SizedBox(height: 48),
          Responsive.isMobile(context)
              ? Column(
                  children: [
                    _buildInfo(context),
                    const SizedBox(height: 28),
                    _buildForm(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildInfo(context)),
                    const SizedBox(width: 40),
                    Expanded(flex: 6, child: _buildForm(context)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final scope = AppScope.of(context);

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
        label: 'GitHub',
        value: PortfolioData.githubHandle,
        url: PortfolioData.github,
        external: true,
      ),
      _ContactLink(
        icon: Icons.link,
        label: 'LinkedIn',
        value: scope.ar ? 'لينكد إن' : 'LinkedIn',
        url: PortfolioData.linkedIn,
        external: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _ContactLinkCard(item: items[i]),
        ],
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
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
          Text(
            scope.ar ? 'أرسل رسالة' : 'Send a message',
            style: styles.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            scope.ar
                ? 'رسالتك تُفتح عبر تطبيق البريد الخاص بك.'
                : 'Your message opens in your own email app.',
            style: styles.bodySmall.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(
                  context,
                  controller: _name,
                  label: scope.ar ? 'الاسم' : 'Name',
                  hint: scope.ar ? 'اسمك الكامل' : 'Your name',
                  kind: _FieldKind.name,
                ),
                const SizedBox(height: 18),
                _buildField(
                  context,
                  controller: _email,
                  label: scope.ar ? 'البريد الإلكتروني' : 'Email',
                  hint: 'you@email.com',
                  kind: _FieldKind.email,
                ),
                const SizedBox(height: 18),
                _buildField(
                  context,
                  controller: _message,
                  label: scope.ar ? 'الرسالة' : 'Message',
                  hint: scope.ar
                      ? 'أخبرني عن مشروعك...'
                      : 'Tell me about your project...',
                  kind: _FieldKind.message,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: _sending
                      ? '...'
                      : (scope.ar ? 'إرسال الرسالة' : 'Send Message'),
                  icon: Icons.send_rounded,
                  expanded: true,
                  onTap: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        return scope.ar ? 'هذا الحقل مطلوب' : 'This field is required';
      }
      if (kind == _FieldKind.email &&
          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
        return scope.ar ? 'بريد إلكتروني غير صالح' : 'Enter a valid email';
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
          textDirection: scope.direction,
        ),
      ],
    );
  }
}

enum _FieldKind { name, email, message }

class _ContactLink {
  final IconData icon;
  final String label;
  final String value;
  final String? url;
  final bool external;

  const _ContactLink({
    required this.icon,
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
            child: Icon(item.icon, size: 20, color: palette.primary),
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
