import 'package:flutter/material.dart';
import '../constants/test_keys.dart';
import '../widgets/test_id.dart';

class CheckoutCompleteScreen extends StatelessWidget {
  const CheckoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TestId(
                  TestKeys.completeSuccessIcon,
                  child: Container(
                    key: TestKeys.completeSuccessIcon,
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TestId(
                  TestKeys.completeThankYouText,
                  child: Text(
                    'Thank You!',
                    key: TestKeys.completeThankYouText,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                TestId(
                  TestKeys.completeMessageText,
                  child: Text(
                    'Your order has been placed successfully.\nYou will receive a confirmation shortly.',
                    key: TestKeys.completeMessageText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                TestId(
                  TestKeys.completeContinueButton,
                  child: ElevatedButton(
                    key: TestKeys.completeContinueButton,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
