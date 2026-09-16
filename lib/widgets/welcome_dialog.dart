import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import 'test_id.dart';

/// 'emma@demoapp.com' -> 'Emma'. Falls back to a neutral greeting when the
/// local part of the username is unusable.
String welcomeDisplayName(String username) {
  final local = username.split('@').first.trim();
  if (local.isEmpty) return 'there';
  return local[0].toUpperCase() + local.substring(1);
}

/// Celebratory greeting shown once, after the home screen has rendered its
/// first frame following a login.
///
/// Dismissal is deliberately single-path: the barrier is inert and [PopScope]
/// blocks the Android back button, so the only way out is the Continue button.
/// That keeps the flow deterministic for UI automation.
class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key, required this.name});

  final String name;

  static Future<void> show(BuildContext context, {required String name}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => WelcomeDialog(name: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The brand pink, not colorScheme.primary - the seeded scheme derives a
    // muted rose that looks washed out beside the themed buttons.
    final brand = theme.primaryColor;

    return PopScope(
      canPop: false,
      child: TestId(
               TestKeys.homeWelcomeDialog,
               child: Dialog(
        key: TestKeys.homeWelcomeDialog,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        clipBehavior: Clip.antiAlias,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(brand: brand),
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TestId(
                      TestKeys.homeWelcomeMessage,
                      child: Text(
                        'Welcome, $name!',
                        key: TestKeys.homeWelcomeMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: brand,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Good to see you again. Your next favourite dress is '
                      'waiting in the new collection.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: TestId(
                               TestKeys.homeWelcomeContinueButton,
                               child: ElevatedButton(
                        key: TestKeys.homeWelcomeContinueButton,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Start shopping'),
                      ),
                             ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
             ),
    );
  }
}

/// Gradient banner with the app mark, sized to stay clear of small screens.
class _Header extends StatelessWidget {
  const _Header({required this.brand});

  final Color brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // A tonal shift of the brand pink, so the banner stays on-brand in
          // both themes.
          colors: [brand, _gradientEnd(brand)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft decorative bubbles, clipped by the dialog's rounded corners.
          Positioned(top: -34, right: -22, child: _bubble(108, 0.14)),
          Positioned(bottom: -42, left: -28, child: _bubble(120, 0.10)),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/logo.png',
                width: 68,
                height: 68,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _gradientEnd(Color brand) {
    final hsl = HSLColor.fromColor(brand);
    return hsl
        .withHue((hsl.hue + 22) % 360)
        .withSaturation((hsl.saturation + 0.10).clamp(0.0, 1.0))
        .withLightness((hsl.lightness + 0.20).clamp(0.0, 1.0))
        .toColor();
  }

  Widget _bubble(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      );
}
