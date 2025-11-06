// lib/features/tora-pet/state/mascota_state.dart
import 'package:flutter/material.dart';
import 'package:tora_frontend/features/tora-pet/models/accessory.dart';
import 'package:tora_frontend/features/tora-pet/models/background.dart';
import 'package:tora_frontend/features/tora-pet/util/accesori_adjustament.dart';
import 'package:tora_frontend/features/tora-pet/util/accessory_repository.dart';

class MascotaState extends ChangeNotifier {
  final AccessoryRepository repo;
  MascotaState(this.repo) {
    repo.addListener(notifyListeners);
  }

  // IDs actuales (seguro empezar con 'none')
  String _currentHatId = 'none';
  String _currentGlassesId = 'none';
  String _currentBackgroundId = 'none';

  // Exponer listas reactivas
  List<Accessory> get availableHats => repo.hats;
  List<Accessory> get availableGlasses => repo.glasses;

  // Flag simple de "cargado"
  bool get isReady => availableHats.isNotEmpty && availableGlasses.isNotEmpty;

  // Helpers seguros
  Accessory? _findById(List<Accessory> list, String id) {
    if (list.isEmpty) return null;
    for (final a in list) {
      if (a.id == id) return a;
    }
    // fallback: intenta 'none', sino null
    for (final a in list) {
      if (a.id == 'none') return a;
    }
    return null;
  }

  // SOMBREROS
  String get currentHatId => _currentHatId;
  String? get currentHatPath {
    final a = _findById(availableHats, _currentHatId);
    return a?.path;
  }

  HatAdjustment get currentHatAdjustment {
    // fallback a 'none' -> 'pirata' -> primer ajuste definido
    if (hatAdjustments.containsKey(_currentHatId)) {
      return hatAdjustments[_currentHatId]!;
    }
    if (hatAdjustments.containsKey('none')) {
      return hatAdjustments['none']!;
    }
    return hatAdjustments['pirata'] ?? hatAdjustments.values.first;
  }

  // LENTES
  String get currentGlassesId => _currentGlassesId;
  String? get currentGlassesPath {
    final a = _findById(availableGlasses, _currentGlassesId);
    return a?.path;
  }

  GlassesAdjustment get currentGlassesAdjustment {
    if (glassesAdjustments.containsKey(_currentGlassesId)) {
      return glassesAdjustments[_currentGlassesId]!;
    }
    if (glassesAdjustments.containsKey('none')) {
      return glassesAdjustments['none']!;
    }
    return glassesAdjustments['negros'] ?? glassesAdjustments.values.first;
  }

  // FONDOS
  String get currentBackgroundId => _currentBackgroundId;
  String? get currentBackgroundPath {
    final bg = availableBackgrounds
        .where((b) => b.id == _currentBackgroundId)
        .cast<Background?>()
        .firstWhere((_) => true, orElse: () => null);
    return bg?.path;
  }

  // Mutadores
  void changeHat(String newHatId) {
    _currentHatId = newHatId;
    notifyListeners();
  }

  void changeGlasses(String newGlassesId) {
    _currentGlassesId = newGlassesId;
    notifyListeners();
  }

  void changeBackground(String newBackgroundId) {
    _currentBackgroundId = newBackgroundId;
    notifyListeners();
  }

  // Compra (repo notifica y listas se reconstruyen)
  Future<void> buyHat(String hatId) async {
    await repo.buyById(AccessoryKind.hat, hatId);
    _currentHatId = hatId; // autoseleccionar
    notifyListeners();
  }

  Future<void> buyGlasses(String glassesId) async {
    await repo.buyById(AccessoryKind.glasses, glassesId);
    _currentGlassesId = glassesId;
    notifyListeners();
  }

  @override
  void dispose() {
    repo.removeListener(notifyListeners);
    super.dispose();
  }
}
