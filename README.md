# DemoApp by taqelah! community

A Flutter demo app built for **mobile UI test automation practice**. Features a women's dress e-commerce flow with 32 unique AI-generated products, plus dedicated test screens for gestures, forms, permissions, notifications, and more.

Built with automation-friendly **test Keys** on every interactive element for Appium, Patrol, and Flutter integration testing.

## Screenshots

| Home | Catalog | Product Detail | Cart |
|------|---------|---------------|------|
| Category cards | 2-column grid with pagination | Fixed bottom bar with Add to Cart | Swipe to delete |

## Features

### E-Commerce Flow
- **Login** — Email/password with validation, demo credentials displayed
- **Home** — Hero banner + 4 category cards (Casual, Evening, Party, Boho)
- **Product Catalog** — 32 unique products, 6-per-page lazy loading, search, sort
- **Product Detail** — Image, color picker, quantity selector, fixed Add to Cart bar
- **Cart** — Quantity controls, swipe-to-delete, total price
- **Checkout** — 3-step flow: shipping info form → order review → confirmation
- **About** — App info, feature list, dark mode toggle

### Test Automation Screens
| Screen | Route | What You Can Test |
|--------|-------|-------------------|
| **Gestures** | `/gestures` | Swipe left/right, drag-and-drop reorder, long-press context menu, double-tap zoom, pinch-to-zoom |
| **WebView** | `/webview` | URL input, embedded browser, back/forward/refresh navigation |
| **Dialogs & Alerts** | `/dialogs` | Alert dialog, bottom sheet, snackbar, date picker, time picker, simple dialog, full-screen dialog |
| **Form Validation** | `/form-showcase` | Text, email, phone, number, password, dropdown, checkbox, radio, switch, slider, date/time pickers, submit/reset |
| **Permissions** | `/permissions` | Camera, location, storage — native OS permission dialogs |
| **Notifications** | `/notifications` | Instant system notification, scheduled notification (5 sec), in-app banner, dialog, snackbar |
| **Tabs & Navigation** | `/tabs-navigation` | Tab bar switching, PageView horizontal swiping, bottom navigation bar |
| **Camera** | `/camera` | Live camera preview, capture photo, switch front/back camera |
| **Location** | `/location` | GPS coordinates, live tracking with history, accuracy/altitude |

### Additional Features
- **Dark mode** — Toggle from drawer or About screen, persisted via SharedPreferences
- **Search** — Real-time product filtering on catalog
- **Pull-to-refresh** — On catalog (removed to fix scroll, available via code)
- **200+ Test Keys** — Every button, field, card, toggle has a unique `Key` for automation
- **AI-generated images** — 32 unique dress images, no copyright issues
- **Taqelah logo** — Custom app icon on Android and iOS

## Test IDs

All interactive elements have Appium-compatible Keys defined in [`lib/constants/test_keys.dart`](lib/constants/test_keys.dart). Naming convention:

```
screenName_widgetType_descriptor
```

Examples:
- `login_username_field`, `login_button`
- `catalog_product_card_1`, `catalog_sort_button`
- `detail_add_to_cart_button`, `cart_checkout_button`
- `form_email_field`, `form_submit_button`

## Demo Credentials

```
Username: emma@demoapp.com
Password: 10203040
```

## Getting Started

### Prerequisites
- Flutter SDK 3.11+
- Android SDK / Xcode for iOS

### Run

```bash
# Get dependencies
flutter pub get

# Run on Android
flutter run -d <android-device>

# Run on iOS
flutter run -d <ios-device>

# Run tests
flutter test
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release --no-codesign
```

## Project Structure

```
lib/
├── main.dart                          # App entry, routes, theme
├── constants/
│   ├── app_constants.dart             # Products, credentials, categories
│   └── test_keys.dart                 # 200+ automation test Keys
├── models/
│   ├── product.dart                   # Product model with JSON
│   ├── cart_item.dart                 # Cart item with quantity
│   └── checkout_info.dart             # Shipping info
├── services/
│   ├── local_storage_service.dart     # SharedPreferences wrapper
│   └── notification_service.dart      # Local notifications
├── screens/
│   ├── splash_screen.dart             # Animated splash
│   ├── login_screen.dart              # Authentication
│   ├── home_screen.dart               # Category cards
│   ├── product_catalog_screen.dart    # Product grid with pagination
│   ├── product_detail_screen.dart     # Product view + add to cart
│   ├── cart_screen.dart               # Shopping cart
│   ├── checkout_info_screen.dart      # Shipping form
│   ├── checkout_review_screen.dart    # Order review
│   ├── checkout_complete_screen.dart  # Order confirmation
│   ├── about_screen.dart              # App info
│   ├── gesture_demo_screen.dart       # Gesture testing
│   ├── webview_screen.dart            # Embedded browser
│   ├── dialog_showcase_screen.dart    # Dialog types
│   ├── form_showcase_screen.dart      # Form inputs
│   ├── permission_screen.dart         # OS permissions
│   ├── notification_screen.dart       # Notifications
│   ├── tabs_navigation_screen.dart    # Tabs & nav
│   ├── camera_screen.dart             # Camera
│   └── location_screen.dart           # GPS location
├── widgets/
│   ├── app_drawer.dart                # Navigation drawer
│   ├── cart_badge.dart                # Cart icon with count
│   ├── product_card.dart              # Product grid tile
│   ├── quantity_selector.dart         # +/- quantity
│   └── sort_dialog.dart               # Sort options
└── theme/
    └── app_theme.dart                 # Light + dark themes
```

## Tests

51 tests covering models, constants, widgets, and screens:

```bash
flutter test
```

| Test Area | Count | Coverage |
|-----------|-------|----------|
| Product model | 6 | Create, serialize, deserialize, roundtrip |
| CartItem model | 5 | Create, totalPrice, quantity, serialize |
| CheckoutInfo model | 3 | Defaults, constructor, mutation |
| AppConstants | 10 | Products, categories, IDs, images, prices |
| LoginScreen | 5 | Render, validation, credentials, password toggle |
| CheckoutInfo screen | 3 | Fields, validation, valid input |
| AboutScreen | 6 | Elements, branding, features, dark mode |
| CheckoutComplete | 2 | Success elements, messages |
| ProductCard widget | 4 | Display, tap, add to cart |
| QuantitySelector | 4 | Display, increment, decrement, disabled |
| App smoke test | 1 | App launches |

## Tech Stack

- **Flutter** 3.41.6
- **Dart** 3.11.4
- **State management** — setState
- **Storage** — SharedPreferences
- **Packages** — webview_flutter, permission_handler, camera, geolocator, flutter_local_notifications

## Package Name

- **Android**: `com.taqelah.demo_app`
- **iOS**: `com.taqelah.demoApp`

## License

This is a demo app from the [taqelah!](https://www.taqelah.sg) community for learning mobile UI test automation.
