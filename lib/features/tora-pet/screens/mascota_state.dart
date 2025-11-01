import 'package:flutter/material.dart';

// ------------------------------------
// CLASES DE AJUSTE
// ------------------------------------

// Clase de ajuste para Sombreros
class HatAdjustment {
  final double widthPercentage;
  final double leftPercentage;
  final double topPercentage;

  HatAdjustment({
    required this.widthPercentage,
    required this.leftPercentage,
    required this.topPercentage,
  });
}

// Clase de ajuste para Lentes
class GlassesAdjustment {
  final double widthPercentage;
  final double leftPercentage;
  final double topPercentage;

  GlassesAdjustment({
    required this.widthPercentage,
    required this.leftPercentage,
    required this.topPercentage,
  });
}

// ------------------------------------
// ACCESORIOS (GENERAL)
// ------------------------------------
class Accessory {
  final String id;
  final String path;
  final String name;

  Accessory(this.id, this.path, this.name);
}

// ------------------------------------
// CONFIGURACIÓN DE SOMBREROS
// ------------------------------------

// Lista de sombreros
final List<Accessory> availableHats = [
  Accessory('none', '', 'Sin Sombrero'),
  Accessory('pirata', 'assets/images/tora/cumple.png', 'Sombrero Pirata'),
  Accessory('santa', 'assets/images/tora/pirata_new.png', 'Gorro de Santa'),
  Accessory('andaluz', 'assets/images/tora/test.png', 'Sombrero Andaluz'),
  Accessory('sombrero_de_paja', 'assets/images/tora/sombrero_de_paja.png', 'Sombrero de Paja'),
  Accessory('sombrero_de_copa', 'assets/images/tora/sombrero_de_copa.png', 'Sombrero de Copa'),
];

// Ajustes específicos por sombrero
final Map<String, HatAdjustment> hatAdjustments = {
  'pirata': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'santa': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'andaluz': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.02,
  ),
  'sombrero_de_paja': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.04,
  ),
  'sombrero_de_copa': HatAdjustment(
    widthPercentage: 0.40,
    leftPercentage: 0.30,
    topPercentage: 0.08,
  ),
};

// ------------------------------------
// CONFIGURACIÓN DE LENTES
// ------------------------------------

// Lista de lentes
final List<Accessory> availableGlasses = [
  Accessory('none', '', 'Sin Lentes'),
  Accessory('negros', 'assets/images/tora/lentes.png', 'Lentes Negros'),
];

// Ajustes específicos para los lentes
final Map<String, GlassesAdjustment> glassesAdjustments = {
  'negros': GlassesAdjustment(
    widthPercentage: 0.35,
    leftPercentage: 0.325,
    topPercentage: 0.19,
  ),
};

// ------------------------------------
// FONDOS (BACKGROUND)
// ------------------------------------
class Background {
  final String id;
  final String path;
  final String name;

  Background(this.id, this.path, this.name);
}

// Lista de fondos disponibles
final List<Background> availableBackgrounds = [
  Background('none', '', 'Fondo Neutro'),
  Background('school', 'assets/images/backgrounds/school.png', 'Escuela'),
  Background('room', 'assets/images/backgrounds/room.png', 'Habitación'),
  Background('jungle', 'assets/images/backgrounds/jungle.png', 'Selva'),
];

// ------------------------------------
// ESTADO PRINCIPAL DE LA MASCOTA
// ------------------------------------
class MascotaState extends ChangeNotifier {
  // Estados
  String _currentHatId = 'pirata';
  String _currentBackgroundId = 'none';
  String _currentGlassesId = 'none';

  // --- SOMBREROS ---
  String get currentHatId => _currentHatId;
  String? get currentHatPath {
    return availableHats
        .firstWhere((hat) => hat.id == _currentHatId, orElse: () => availableHats.first)
        .path;
  }

  HatAdjustment get currentHatAdjustment {
    return hatAdjustments[_currentHatId] ?? hatAdjustments['pirata']!;
  }

  // --- LENTES ---
  String get currentGlassesId => _currentGlassesId;
  String? get currentGlassesPath {
    return availableGlasses
        .firstWhere((g) => g.id == _currentGlassesId, orElse: () => availableGlasses.first)
        .path;
  }

  GlassesAdjustment get currentGlassesAdjustment {
    return glassesAdjustments[_currentGlassesId] ?? glassesAdjustments['negros']!;
  }

  // --- FONDOS ---
  String get currentBackgroundId => _currentBackgroundId;
  String? get currentBackgroundPath {
    return availableBackgrounds
        .firstWhere((bg) => bg.id == _currentBackgroundId, orElse: () => availableBackgrounds.first)
        .path;
  }

  // --- MÉTODOS DE CAMBIO DE ESTADO ---
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
}
