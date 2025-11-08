import 'package:flutter/material.dart';
import 'package:tora_frontend/features/tora-pet/models/coin.dart';
import 'package:tora_frontend/features/tora-pet/services/tora_coins_service.dart';

class CoinsState extends ChangeNotifier {
  int? _coins;
  bool _loading = false;
  String? _error;

  int? get coins => _coins;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true; notifyListeners();
    try {
      final Coin c = await ToraCoinsService.getCoins();
      _coins = c.coins;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> add(int amount) async {
    _coins = (_coins ?? 0) + amount; notifyListeners();
    try {
      final Coin c = await ToraCoinsService.addCoins(amount);
      _coins = c.coins;
      notifyListeners();
    } catch (e) {
      _error = e.toString(); notifyListeners();
      rethrow;
    }
  }

  Future<void> deduct(int price) async {
    final next = (_coins ?? 0) - price;
    if (next < 0) throw StateError('Saldo insuficiente');
    _coins = next; notifyListeners();
    try {
      final Coin c = await ToraCoinsService.deductCoins(next);
      _coins = c.coins; notifyListeners();
    } catch (e) {
      _error = e.toString(); notifyListeners();
      rethrow;
    }
  }

  Future<void> ensureLoaded() async {
    if (_coins == null && !_loading) await load();
  }
}