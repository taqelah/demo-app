# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Flutter demo app (`lime_demo_app`, displayed as "DemoApp") built by the taqelah! community as a **practice target for mobile UI test automation** (Appium, Patrol, Flutter integration tests). It is a women's dress e-commerce flow plus a set of dedicated screens that exercise gestures, dialogs, forms, permissions, notifications, camera, location, WebView, and tab navigation.

Because the app's purpose is to be automated against, the automation surface is a first-class API: every interactive widget carries a `Key` from `lib/constants/test_keys.dart`. Treat those keys as a public contract — renaming or dropping one breaks downstream test suites that this repo doesn't contain.

## Commands

```bash
flutter pub get
flutter analyze                       # lints: flutter_lints via analysis_options.yaml
flutter test                          # unit + widget tests (test/ only)
flutter test test/screens/login_screen_test.dart          # single file
flutter test --plain-name 'should render all about elements'   # single test by name
flutter run -d <device-id>

# Integration tests need a booted device/emulator; they live outside test/ so
# `flutter test` (and CI) does not pick them up.
flutter test integration_test/safe_area_test.dart -d <device-id>

flutter build apk --release
flutter build ios --release --no-codesign
```

CI (`.github/workflows/build-and-release.yml`) is `workflow_dispatch`-only: it pins Flutter 3.41.6, runs `flutter test`, builds a **debug** Android APK and a debug iOS simulator `.app`, and attaches both to a prerelease GitHub release under the version tag supplied as workflow input. The iOS job also asserts the `demoapp` URL scheme is still present in `ios/Runner/Info.plist`.

## Architecture

**No state management package and no repository layer.** Every screen is a `StatefulWidget` using `setState`. There are exactly three cross-cutting mechanisms:

1. **`LocalStorageService`** (`lib/services/local_storage_service.dart`) — a static SharedPreferences wrapper holding the four pieces of global state: login flag, username, theme, and the cart (JSON-encoded `List<CartItem>`).
2. **`ThemeController`** — an `InheritedWidget` defined in `lib/main.dart` exposing `toggleTheme`/`isDarkMode`. Any widget tree containing a screen that reads it (About, drawer) must be wrapped in one, which is why widget tests build `MaterialApp(home: ThemeController(...))` rather than pumping the screen directly.
3. **Named routes with positional arguments** — all routes are declared in the `routes:` map in `lib/main.dart`. Screens receive data via `ModalRoute.of(context)!.settings.arguments` and cast it: `Product` for `/product-detail`, category `String?` for `/catalog`, `CheckoutInfo` for `/checkout-review`.

**Cart state is deliberately not shared in memory.** Each screen reloads the cart from SharedPreferences in `initState`/`didChangeDependencies`, and callers refresh after navigation with `Navigator.pushNamed(...).then((_) => _loadCart())`. When adding a screen that shows the cart badge or mutates the cart, follow that same load-mutate-save-reload cycle rather than introducing shared in-memory state.

**Product data is a hardcoded `const` list** of 32 items in `lib/constants/app_constants.dart`, alongside the demo credentials (`emma@demoapp.com` / `10203040`) and `pageSize` (6). There is no backend; the catalog simulates network latency with a `Future.delayed(800ms)` in `_loadMoreProducts`, filters by category from the route argument, and sorts/searches in memory.

**Startup order** (`main.dart` → `SplashScreen`): notification init is wrapped in a try/catch so a failure never blocks launch; the splash waits 2s then routes to `/home` or `/login` based on the persisted login flag. `DeepLinkService` is initialized in a post-frame callback so the navigator exists before an initial cold-start link is routed.

**Deeplink login bypass** — `demoapp://login?username=..&password=..` (`lib/services/deep_link_service.dart`). Matching credentials save the session and `pushNamedAndRemoveUntil('/home')`; anything else lands on `/login` with an error SnackBar. Registered in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.

## Conventions that matter here

- **Test keys**: naming is `screenName_widgetType_descriptor` (`login_username_field`, `catalog_product_card_1`). Per-item keys are factory methods, e.g. `TestKeys.catalogProductCard(int id)`. Add a key for every new interactive element; never inline a raw `Key('...')` string in a screen.
- **Every keyed widget is also wrapped in `TestId`** (`lib/widgets/test_id.dart`), which republishes the key string through `Semantics(identifier:, label:)` so Appium's native drivers see it — a Flutter `Key` alone never reaches the platform. `TestId` derives the id from the `Key` itself, so pass the same `TestKeys` entry to both and they cannot drift. Verified mapping: iOS `accessibilityIdentifier` and Android `resource-id` for everything; Android `content-desc` for everything except text fields, whose label Flutter routes to hint text instead.
- **Bottom insets**: the app is drawn edge-to-edge (Android 15+/SDK 35+, iOS). Controls anchored to the bottom of the window must add `MediaQuery.paddingOf(context).bottom` to their bottom padding — `paddingOf`, not `viewPaddingOf`, so it collapses to 0 when the keyboard pushes the bar clear. `integration_test/safe_area_test.dart` asserts each such control ends at or above `screenHeight - viewPadding.bottom`; it only proves anything on a device that actually reports a bottom inset.
- **Package names**: Android `com.taqelah.demo_app`, iOS `com.taqelah.demoApp`. The Dart package (used in test imports) is `lime_demo_app`.
