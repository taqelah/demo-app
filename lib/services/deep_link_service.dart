import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'local_storage_service.dart';

/// Handles custom-scheme deeplinks of the form:
///   demoapp://login?username=..&password=..
///
/// When the credentials in the link match the demo credentials in
/// [AppConstants], the session is saved and the app jumps straight to `/home`,
/// skipping the login screen. Otherwise the user is sent to `/login` with an
/// error SnackBar.
class DeepLinkService {
  DeepLinkService(this.navigatorKey, this.messengerKey);

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  /// Wire up both cold-start (initial link) and warm-start (stream) handling.
  Future<void> init() async {
    // App launched from a terminated state via a deeplink.
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handle(initialUri);
      }
    } catch (_) {
      // Ignore malformed initial links.
    }

    // App already running (or backgrounded) when the deeplink arrives.
    _subscription = _appLinks.uriLinkStream.listen(
      _handle,
      onError: (_) {},
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _handle(Uri uri) {
    if (uri.scheme != 'demoapp' || uri.host != 'login') return;

    final username = uri.queryParameters['username']?.trim() ?? '';
    final password = uri.queryParameters['password'] ?? '';

    if (username == AppConstants.validUsername &&
        password == AppConstants.validPassword) {
      _loginAndGoHome(username);
    } else {
      _goToLoginWithError();
    }
  }

  Future<void> _loginAndGoHome(String username) async {
    await LocalStorageService.saveLoginState(true, username);
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void _goToLoginWithError() {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
    messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Invalid deeplink credentials')),
      );
  }
}
