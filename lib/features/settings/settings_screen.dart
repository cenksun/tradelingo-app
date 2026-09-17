import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/user_profile.dart';
import '../learn/learner_controller.dart';
import '../onboarding/onboarding_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final state = ref.watch(learnerControllerProvider).value;
    if (state == null) return const Scaffold(body: TpLoadingState());

    final settings = state.settings;
    final controller = ref.read(learnerControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.huge),
          children: [
            const TpSectionHeader(
              title: 'Appearance',
              padding: EdgeInsets.fromLTRB(0, Gap.md, 0, Gap.md),
            ),
            TpCard(
              child: Column(
                children: [
                  Text(
                    'Theme',
                    style: context.texts.titleSmall,
                    textAlign: TextAlign.left,
                  ),
                  const VGap(Gap.md),
                  Row(
                    children: [
                      for (final choice in ThemeChoice.values)
                        Padding(
                          padding: const EdgeInsets.only(right: Gap.sm),
                          child: TpFilterChip(
                            label: choice.label,
                            selected: settings.theme == choice,
                            onTap: () => controller.updateSettings(
                              settings.copyWith(theme: choice),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: Gap.xxl),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: settings.reduceMotion,
                    title: const Text('Reduce motion'),
                    subtitle: const Text(
                      'Shortens celebratory animations across the app.',
                    ),
                    onChanged: (v) => controller.updateSettings(
                      settings.copyWith(reduceMotion: v),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: settings.showVolume,
                    title: const Text('Show volume on charts'),
                    subtitle: const Text(
                      'Adds a volume pane beneath simulator charts.',
                    ),
                    onChanged: (v) => controller.updateSettings(
                      settings.copyWith(showVolume: v),
                    ),
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'Feedback'),
            TpCard(
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: settings.hapticsEnabled,
                    title: const Text('Haptics'),
                    subtitle: const Text(
                      'A short vibration when an answer is checked.',
                    ),
                    onChanged: (v) => controller.updateSettings(
                      settings.copyWith(hapticsEnabled: v),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: settings.soundEnabled,
                    title: const Text('Sound effects'),
                    subtitle: const Text(
                      'Uses the device\'s built-in interface sounds only.',
                    ),
                    onChanged: (v) => controller.updateSettings(
                      settings.copyWith(soundEnabled: v),
                    ),
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'Learning'),
            TpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily goal', style: context.texts.titleSmall),
                  const VGap(Gap.md),
                  Row(
                    children: [
                      for (final minutes in const [5, 10, 15, 20])
                        Padding(
                          padding: const EdgeInsets.only(right: Gap.sm),
                          child: TpFilterChip(
                            label: '$minutes min',
                            selected: state.profile.dailyGoalMinutes == minutes,
                            onTap: () async {
                              await controller.updateSettings(
                                settings.copyWith(dailyGoalMinutes: minutes),
                              );
                              await controller.updateProfile(
                                state.profile.copyWith(
                                  dailyGoalMinutes: minutes,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: Gap.xxl),
                  Text('Lesson reminders', style: context.texts.titleSmall),
                  const VGap(Gap.sm),
                  Text(
                    'TradePath does not schedule notifications. The app works '
                    'entirely offline and asks for no permissions, so a reminder '
                    'toggle here would not do anything — rather than show a switch '
                    'that does nothing, there is none.',
                    style: context.texts.bodySmall,
                  ),
                  const VGap(Gap.sm),
                  Text(
                    'Your streak survives until the end of the following day, so a '
                    'single missed evening does not cost it.',
                    style: context.texts.bodySmall,
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'Simulator'),
            TpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default risk per trade',
                    style: context.texts.titleSmall,
                  ),
                  const VGap(Gap.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: settings.defaultRiskPercent.clamp(0.1, 10),
                          min: 0.1,
                          max: 10,
                          divisions: 99,
                          label: Fmt.percent(
                            settings.defaultRiskPercent,
                            decimals: 1,
                          ),
                          onChanged: (v) => controller.updateSettings(
                            settings.copyWith(defaultRiskPercent: v),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        child: Text(
                          Fmt.percent(settings.defaultRiskPercent, decimals: 1),
                          style: context.texts.titleSmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: Gap.xxl),
                  Text(
                    'Starting virtual balance',
                    style: context.texts.titleSmall,
                  ),
                  const VGap(Gap.md),
                  Row(
                    children: [
                      for (final amount in const [
                        1000.0,
                        5000.0,
                        10000.0,
                        50000.0,
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: Gap.sm),
                          child: TpFilterChip(
                            label: Fmt.compact(amount),
                            selected:
                                settings.simulatorStartingBalance == amount,
                            onTap: () => controller.updateSettings(
                              settings.copyWith(
                                simulatorStartingBalance: amount,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const VGap(Gap.sm),
                  Text(
                    'Takes effect the next time you reset the simulator.',
                    style: context.texts.labelSmall,
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'Data'),
            TpCard(
              child: Column(
                children: [
                  _DangerRow(
                    icon: Icons.restart_alt_rounded,
                    title: 'Reset simulator',
                    body:
                        'Clears the journal, the equity curve and the virtual '
                        'balance. Learning progress is untouched.',
                    onTap: () => _confirm(
                      context,
                      title: 'Reset the simulator?',
                      body:
                          'Your journal entries, equity history and virtual '
                          'balance will be deleted. Lessons, XP, streak and skill '
                          'mastery are not affected.',
                      confirmLabel: 'Reset simulator',
                      onConfirm: controller.resetSimulator,
                    ),
                  ),
                  const Divider(height: Gap.xl),
                  _DangerRow(
                    icon: Icons.school_rounded,
                    title: 'Reset learning progress',
                    body:
                        'Clears lessons, XP, levels, streak, mastery, review queue '
                        'and achievements. The simulator is untouched.',
                    onTap: () => _confirm(
                      context,
                      title: 'Reset learning progress?',
                      body:
                          'All lesson completions, XP, your streak, skill mastery, '
                          'the review queue and achievements will be deleted. This '
                          'cannot be undone.',
                      confirmLabel: 'Reset learning',
                      onConfirm: controller.resetLearningProgress,
                    ),
                  ),
                  const Divider(height: Gap.xl),
                  _DangerRow(
                    icon: Icons.delete_forever_rounded,
                    title: 'Reset everything',
                    body: 'Returns the app to a first-run state.',
                    destructive: true,
                    onTap: () => _confirm(
                      context,
                      title: 'Reset everything?',
                      body:
                          'Everything on this device will be deleted and the app '
                          'will restart from onboarding. This cannot be undone.',
                      confirmLabel: 'Delete everything',
                      onConfirm: () async {
                        await controller.resetEverything();
                        if (context.mounted) context.go('/onboarding');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'About'),
            TpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TradePath', style: context.texts.titleMedium),
                  const VGap(Gap.xs),
                  Text(
                    'An offline-first trading education app. Version 1.0.0.',
                    style: context.texts.bodySmall,
                  ),
                  const VGap(Gap.md),
                  const TpCallout(
                    title: 'Educational disclaimer',
                    message: kEducationalDisclaimer,
                    icon: Icons.gavel_rounded,
                    tone: TpCalloutTone.warning,
                  ),
                  const VGap(Gap.md),
                  Text(
                    'Charts in TradePath are generated educational data, built to '
                    'demonstrate specific structures. They are not recordings of '
                    'real market history. The repository includes an import tool '
                    'for loading real OHLCV data.',
                    style: context.texts.bodySmall,
                  ),
                  const VGap(Gap.md),
                  Text(
                    'Everything is stored on this device. There is no account, no '
                    'sign-in, no analytics and no network connection.',
                    style: context.texts.bodySmall,
                  ),
                  const VGap(Gap.md),
                  Row(
                    children: [
                      Icon(Icons.favorite_rounded, size: 14, color: c.heart),
                      const HGap(Gap.sm),
                      Text(
                        'Hearts refill one every 25 minutes, up to '
                        '${UserProfile.maxHearts}.',
                        style: context.texts.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required Future<void> Function() onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await onConfirm();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$confirmLabel complete.')));
  }
}

class _DangerRow extends StatelessWidget {
  const _DangerRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final color = destructive ? c.danger : c.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.sm),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const HGap(Gap.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.texts.titleSmall?.copyWith(color: color),
                  ),
                  const VGap(Gap.xxs),
                  Text(body, style: context.texts.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}
