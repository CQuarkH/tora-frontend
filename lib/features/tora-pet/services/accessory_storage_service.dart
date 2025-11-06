import 'package:shared_preferences/shared_preferences.dart';

class AccessoryStorageService {
  static const String _keyBoughtAccessories = 'bought_accessories';

  static Future<void> markAsBought(String accessoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final bought = prefs.getStringList(_keyBoughtAccessories) ?? [];
    if (!bought.contains(accessoryId)) {
      bought.add(accessoryId);
      await prefs.setStringList(_keyBoughtAccessories, bought);
    }
  }

  static Future<bool> isBought(String accessoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final bought = prefs.getStringList(_keyBoughtAccessories) ?? [];
    return bought.contains(accessoryId);
  }

  static Future<List<String>> getBoughtIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyBoughtAccessories) ?? [];
  }

  static Future<void> clearBought() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBoughtAccessories);
  }
}