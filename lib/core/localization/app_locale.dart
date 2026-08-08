/// Application strings — English only.
///
/// (The file keeps the historic `app_locale` name, but there is no locale any
/// more — do not re-introduce bilingual support here.)
///
/// The portfolio is intentionally single-language (English). These strings are
/// resolved through [AppScope.strings]; there is no locale state anywhere, so
/// content can never depend on a language switch.
class AppStrings {
  const AppStrings();

  static const AppStrings of = AppStrings();

  // Navigation
  String get navHome => 'Home';
  String get navAbout => 'About';
  String get navSkills => 'Skills';
  String get navExperience => 'Experience';
  String get navProjects => 'Projects';
  String get navContact => 'Contact';
  String get navGitHub => 'GitHub';

  // Hero
  String get heroRole => 'Backend Developer';
  String get heroLocation => 'Syria';
  String get heroHeadline1 => 'Scalable backend systems,';
  String get heroHeadline2 => 'clean APIs and real integrations.';
  String get heroIntro =>
      'I build reliable, high-performance server-side applications with '
      'Laravel, PHP and MySQL — from RESTful APIs to real-time systems and '
      'third-party integrations.';
  String get heroCtaProjects => 'View Projects';
  String get heroCtaContact => 'Get In Touch';
  String get heroScroll => 'Scroll to explore';

  // Contact form
  String get formTitle => 'Send a message';
  String get formHint =>
      'Your message is delivered straight to my inbox — no account needed.';
  String get formFieldName => 'Name';
  String get formFieldNameHint => 'Your full name';
  String get formFieldEmail => 'Email';
  String get formFieldMessage => 'Message';
  String get formFieldMessageHint => 'Tell me about your project…';
  String get formSubmit => 'Send Message';
  String get formSending => 'Sending…';
  String get formErrorEmpty => 'This field is required';
  String get formErrorEmail => 'Enter a valid email';
  String get formSuccessTitle => 'Message sent';
  String get formSuccessBody =>
      'Thanks for reaching out! I\'ll get back to you as soon as I can.';
  String get formErrorTitle => 'Couldn\'t send';
  String get formErrorBody =>
      'The message could not be delivered. Please try again, or email me '
      'directly.';
  String get formSendAnother => 'Send another message';
  String get formTryAgain => 'Try again';

  // About stats (derived exclusively from the portfolio JSON)
  String get statProjects => 'Projects';
  String get statExperience => 'Experience';
  String get statSkills => 'Skills';
  String get statLanguages => 'Languages';

  // Hero terminal
  String get termWho => 'whoami';
  String get termIdentity => 'backend-engineer';
  String get termStack => 'stack';
  String get termStackValue => 'Laravel • PHP • MySQL • REST API';
  String get termFocus => 'focus';
  String get termFocusValue => 'Scalability • APIs • Integrations';
  String get termStatus => '● 200 OK';

  // Section headers
  String get eyebrowAbout => 'PROFILE';
  String get aboutTitle => 'Backend Engineer with a product mindset';
  String get aboutSubtitle =>
      'How I approach software engineering and what I focus on.';

  String get eyebrowSkills => 'SKILLS';
  String get skillsTitle => 'Skills & Technology Stack';
  String get skillsSubtitle =>
      'The technologies and practices I use to ship robust backend systems.';

  String get eyebrowExperience => 'EXPERIENCE';
  String get experienceTitle => 'Professional Experience';
  String get experienceSubtitle =>
      'My journey building real products in production.';

  String get eyebrowProjects => 'PROJECTS';
  String get projectsTitle => 'Featured Projects';
  String get projectsSubtitle => 'Backend systems I designed, built and shipped.';

  String get eyebrowCapabilities => 'CAPABILITIES';
  String get capabilitiesTitle => 'Engineering Capabilities';
  String get capabilitiesSubtitle => 'Core strengths I bring to every codebase.';

  String get eyebrowEducation => 'EDUCATION';
  String get educationTitle => 'Education';
  String get languagesTitle => 'Languages';

  String get eyebrowContact => 'CONTACT';
  String get contactTitle => 'Let\'s build something reliable';
  String get contactSubtitle =>
      'Have a backend project in mind? I\'m available for freelance and '
      'full-time opportunities.';

  String get footerRights => 'Tareq Salha';
  String get footerTagline => 'Backend Developer';
  String get footerBuilt => '© 2026 Tareq Salha · Built with Flutter';

  // Project details dialog
  String get dialogClose => 'Close';
  String get dialogRole => 'My role';
  String get dialogContributions => 'Key contributions';
  String get dialogTech => 'Technology stack';
  String get dialogLanguages => 'Languages';
  String get cardDetails => 'View details';
  String get cardRole => 'Role';
  String get cardContributions => 'Contributions';
  String get keyAchievements => 'Key achievements';

  // Startup gate (loading / error screens)
  String get gateLoadingTitle => 'Loading portfolio';
  String get gateLoadingSubtitle =>
      'Fetching the latest projects, experience and skills…';
  String get gateErrorTitle => 'Couldn\'t load the portfolio';
  String get gateErrorBody =>
      'Something went wrong while reading the portfolio data. Please try '
      'again — or come back in a moment.';
  String get gateRetry => 'Try again';
}
