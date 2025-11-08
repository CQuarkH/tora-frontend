// lib/features/tora-pet/state/mascota_state.dart  (agrega attemptBuy*)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tora_frontend/features/tora-pet/models/accessory.dart';
import 'package:tora_frontend/features/tora-pet/models/background.dart';
import 'package:tora_frontend/features/tora-pet/services/coins_state.dart';
import 'package:tora_frontend/features/tora-pet/util/accesori_adjustament.dart';
import 'package:tora_frontend/features/tora-pet/util/accessory_repository.dart';
import 'package:tora_frontend/features/tora-pet/widgets/dialog_helpers_tora.dart';

class MascotaState extends ChangeNotifier {
  final AccessoryRepository repo;
  MascotaState(this.repo) { repo.addListener(notifyListeners); }

  String _currentHatId = 'none';
  String _currentGlassesId = 'none';
  String _currentBackgroundId = 'none';

  List<Accessory> get availableHats => repo.hats;
  List<Accessory> get availableGlasses => repo.glasses;

  bool get isReady => availableHats.isNotEmpty && availableGlasses.isNotEmpty;

  String get currentHatId => _currentHatId;
  String? get currentHatPath =>
      availableHats.where((h) => h.id == _currentHatId).map((e) => e.path).cast<String?>().firstWhere((_) => true, orElse: () => null);
  HatAdjustment get currentHatAdjustment => hatAdjustments[_currentHatId] ?? (hatAdjustments['none'] ?? hatAdjustments.values.first);

  String get currentGlassesId => _currentGlassesId;
  String? get currentGlassesPath =>
      availableGlasses.where((g) => g.id == _currentGlassesId).map((e) => e.path).cast<String?>().firstWhere((_) => true, orElse: () => null);
  GlassesAdjustment get currentGlassesAdjustment => glassesAdjustments[_currentGlassesId] ?? (glassesAdjustments['none'] ?? glassesAdjustments.values.first);

  String get currentBackgroundId => _currentBackgroundId;
  String? get currentBackgroundPath =>
      availableBackgrounds.where((b) => b.id == _currentBackgroundId).map((b) => b.path).cast<String?>().firstWhere((_) => true, orElse: () => null);

  void changeHat(String id) { _currentHatId = id; notifyListeners(); }
  void changeGlasses(String id) { _currentGlassesId = id; notifyListeners(); }
  void changeBackground(String id) { _currentBackgroundId = id; notifyListeners(); }

  // Compra integral: valida saldo (CoinsState) + confirma + descuenta + marca comprado + autoselecciona
  Future<void> attemptBuyHat(BuildContext context, Accessory hat) async {
    final coinsState = context.read<CoinsState>();
    await coinsState.ensureLoaded();

    final coins = coinsState.coins ?? 0;
    if (coins < hat.price) {
      await showInsufficientCoinsDialog(context, itemName: hat.name, required: hat.price, current: coins);
      return;
    }

    final confirmed = await showConfirmPurchaseDialog(
      context,
      itemName: hat.name,
      price: hat.price,
      currentCoins: coins,
    );
    if (confirmed != true) return;

    await coinsState.deduct(hat.price);
    await repo.buyById(AccessoryKind.hat, hat.id);
    _currentHatId = hat.id;
    notifyListeners();
  }

  Future<void> attemptBuyGlasses(BuildContext context, Accessory glasses) async {
    final coinsState = context.read<CoinsState>();
    await coinsState.ensureLoaded();

    final coins = coinsState.coins ?? 0;
    if (coins < glasses.price) {
      await showInsufficientCoinsDialog(context, itemName: glasses.name, required: glasses.price, current: coins);
      return;
    }

    final confirmed = await showConfirmPurchaseDialog(
      context,
      itemName: glasses.name,
      price: glasses.price,
      currentCoins: coins,
    );
    if (confirmed != true) return;

    await coinsState.deduct(glasses.price);
    await repo.buyById(AccessoryKind.glasses, glasses.id);
    _currentGlassesId = glasses.id;
    notifyListeners();
  }

  @override
  void dispose() { repo.removeListener(notifyListeners); super.dispose(); }
}
