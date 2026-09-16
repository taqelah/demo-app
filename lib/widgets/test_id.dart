import 'package:flutter/material.dart';

/// Publishes a widget's [TestKeys] entry to the *native* accessibility tree so
/// Appium's UiAutomator2 and XCUITest drivers can find it by the same string.
///
/// A Flutter [Key] never reaches the platform, so it is only visible to
/// Flutter-aware drivers (flutter_driver, integration_test, the Appium Flutter
/// driver, Patrol). [Semantics.identifier] maps to `accessibilityIdentifier`
/// on iOS and to the node's `resource-id` on Android, while [Semantics.label]
/// maps to `content-desc` on Android.
///
/// Both carry the same string, so the id is identical on the two platforms.
/// Verified against a live Android 16 emulator and an iPhone 17 Pro simulator:
///
/// | element        | iOS AXIdentifier | Android resource-id | content-desc |
/// |----------------|------------------|---------------------|--------------|
/// | buttons, text  | yes              | yes                 | yes          |
/// | text fields    | yes              | yes                 | *empty*      |
///
/// Flutter routes a text field's semantics label to Android's hint text rather
/// than its content description, so on Android locate by resource-id:
///
/// ```java
/// // iOS
/// driver.findElement(AppiumBy.accessibilityId("login_username_field"));
/// // Android - works for every element, text fields included
/// driver.findElement(AppiumBy.id("login_username_field"));
/// ```
///
/// The trade-off is that screen readers announce the id instead of a prose
/// label. That is deliberate for this app - it exists to be automated against.
/// Dropping `label:` below would restore natural announcements, at the cost of
/// losing the Android content-desc locator.
class TestId extends StatelessWidget {
  const TestId(this.id, {required this.child, super.key});

  /// The same [TestKeys] entry the wrapped widget carries as its [Key].
  final Key id;

  final Widget child;

  /// `Key('login_button')` is a `ValueKey<String>`, so the id is the key.
  String get _identifier => id is ValueKey<String> ? (id as ValueKey<String>).value : '';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: _identifier,
      label: _identifier,
      child: child,
    );
  }
}
