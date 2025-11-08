import 'package:flutter/material.dart';
import 'package:tora_frontend/features/tora-pet/models/accessory.dart';
import 'package:tora_frontend/features/tora-pet/services/accessory_storage_service.dart';

enum AccessoryKind { hat, glasses }

class AccessoryRepository extends ChangeNotifier {
  // Por qué: listas base “catálogo”. Única fuente de verdad.
  static final List<Accessory> _availableHats = [
    const Accessory(id: 'none', path: '', name: 'Sin Sombrero', price: 0, isBought: true),
    const Accessory(id: 'cumple', path: 'assets/images/tora/cumple.png', name: 'Sombrero De Cumpleaños', price: 100, isBought: false),
    const Accessory(id: 'pirata', path: 'assets/images/tora/pirata_new.png', name: 'Gorro de Pirata', price: 100, isBought: false),
    const Accessory(id: 'sombrero_negro', path: 'assets/images/tora/test.png', name: 'Sombrero Negro', price: 100, isBought: false),
    const Accessory(id: 'sombrero_de_paja', path: 'assets/images/tora/sombrero_de_paja.png', name: 'Sombrero de Paja', price: 100, isBought: false),
    const Accessory(id: 'sombrero_de_copa', path: 'assets/images/tora/sombrero_de_copa.png', name: 'Sombrero de Copa', price: 100, isBought: false),
  ];

  static final List<Accessory> _availableGlasses = [
    const Accessory(id: 'none', path: '', name: 'Sin Lentes', price: 0, isBought: true),
    const Accessory(id: 'negros', path: 'assets/images/tora/lentes.png', name: 'Lentes Negros', price: 100, isBought: false),
  ];

  List<Accessory> _hats = const [];
  List<Accessory> _glasses = const [];

  List<Accessory> get hats => _hats;
  List<Accessory> get glasses => _glasses;

  Future<void> load() async {
    final boughtIds = await AccessoryStorageService.getBoughtIds();
    _hats = _buildUpdated(_availableHats, boughtIds);
    _glasses = _buildUpdated(_availableGlasses, boughtIds);
    notifyListeners();
  }

  Future<void> refresh() => load(); // Por qué: API clara para re-sync.

  Future<void> buyById(AccessoryKind kind, String id) async {
    // // VALIDACIÓN DE MONEDAS (COMENTADO)
    // final int userCoins = 0; // TODO: obtiene desde tu estado global.
    // final Accessory? item = (kind == AccessoryKind.hat
    //     ? _hats.firstWhere((e) => e.id == id, orElse: () => _hats.first))
    //     : _glasses.firstWhere((e) => e.id == id, orElse: () => _glasses.first);
    // if (item != null && userCoins < item.price) {
    //   // TODO: mostrar diálogo “monedas insuficientes”
    //   return;
    // }
    // TODO: descontar monedas (comentado)

    await AccessoryStorageService.markAsBought(id);
    await load(); // Por qué: reconstruye listas y notifica inmediatamente.
  }

  List<Accessory> _buildUpdated(List<Accessory> base, List<String> boughtIds) {
    return base.map((a) {
      final forcedBought = a.id == 'none'; // Por qué: “none” siempre disponible.
      final isBought = forcedBought || boughtIds.contains(a.id);
      return a.copyWith(isBought: isBought);
    }).toList(growable: false);
  }
}
