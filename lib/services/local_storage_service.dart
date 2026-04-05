import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class LocalStorageService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUsername = 'username';
  static const _keyThemeIsDark = 'theme_is_dark';
  static const _keyCartItems = 'cart_items';

  static Future<void> saveLoginState(bool loggedIn, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, loggedIn);
    await prefs.setString(_keyUsername, username);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeIsDark, isDark);
  }

  static Future<bool> getThemeIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyThemeIsDark) ?? false;
  }

  static Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_keyCartItems, jsonEncode(jsonList));
  }

  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyCartItems);
    if (jsonString == null || jsonString.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCartItems);
  }
}
