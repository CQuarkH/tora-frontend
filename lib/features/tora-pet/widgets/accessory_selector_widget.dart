// lib/features/tora-pet/widgets/accessory_selector.dart
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tora_frontend/features/tora-pet/models/accessory.dart';
import 'package:tora_frontend/features/tora-pet/widgets/dialog_helpers_tora.dart';

class AccessorySelector extends StatefulWidget {
  final List<Accessory> items;
  final String currentId;
  final void Function(String) onSelect;
  final Future<void> Function(Accessory)? onBuy; 

  const AccessorySelector({
    required this.items,
    required this.currentId,
    required this.onSelect,
    this.onBuy,
    super.key,
  });

  @override
  State<AccessorySelector> createState() => _AccessorySelectorState();
}

class _AccessorySelectorState extends State<AccessorySelector> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: widget.items.map((item) {
          final isSelected = item.id == widget.currentId;
          return _AccessoryTile(
            item: item,
            isSelected: isSelected,
            onAllowedTap: () async {
              widget.onSelect(item.id);
              await _player.play(AssetSource('sounds/pop.mp3'));
            },
            onDeniedTap: () async {
              HapticFeedback.mediumImpact();
              // await _player.play(AssetSource('sounds/denied.mp3'));
            },
            onBuy: widget.onBuy,
          );
        }).toList(),
      ),
    );
  }
}

class _AccessoryTile extends StatefulWidget {
  final Accessory item;
  final bool isSelected;
  final Future<void> Function() onAllowedTap;
  final Future<void> Function() onDeniedTap;
  final Future<void> Function(Accessory)? onBuy;

  const _AccessoryTile({
    required this.item,
    required this.isSelected,
    required this.onAllowedTap,
    required this.onDeniedTap,
    this.onBuy,
  });

  @override
  State<_AccessoryTile> createState() => _AccessoryTileState();
}

class _AccessoryTileState extends State<_AccessoryTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    final item = widget.item;
    final allowed = item.isBought || item.id == 'none';
    if (allowed) {
      await widget.onAllowedTap();
      return;
    }

  
    final int userCoins = 0; 
    if (userCoins < item.price) {
      await showInsufficientCoinsDialog(context, itemName: item.name, required: item.price, current: userCoins);
      _shakeCtrl.forward(from: 0);
      await widget.onDeniedTap();
      return;
    }
    final confirmed = await showConfirmPurchaseDialog(
      context,
      itemName: item.name,
      price: item.price,
      currentCoins: 0, // TODO: reemplazar con coins reales si quieres mostrar
    );
    if (confirmed == true && widget.onBuy != null) {
      await widget.onBuy!(item);
      await widget.onAllowedTap();
      return;
    }

    _shakeCtrl.forward(from: 0);
    await widget.onDeniedTap();
  }

  double _shakeOffset() {
    final t = _shakeCtrl.value;
    const oscillations = 4.0;
    const amplitude = 6.0;
    return math.sin(t * math.pi * oscillations) * amplitude * (1 - t);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isLocked = !(item.isBought || item.id == 'none');

    Widget baseImage;
    if (item.id == 'none') {
      baseImage = const Center(
        child: Text(
          'NONE',
          style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      baseImage = Image.asset(item.path, fit: BoxFit.contain);
    }

    // Badge de precio (solo bloqueados y no "none")
    Widget content = Stack(
      clipBehavior: Clip.none,
      children: [
        baseImage,
       
        if (isLocked)
          Positioned(
            bottom: -8,
            right: -8,
            child: Image.asset('assets/images/tora/lock_icon.png', width: 16, height: 16),
          ),
        if (isLocked && item.id != 'none')
          Positioned(
            bottom: 40,
            right: 10,
            child: _PriceBadge(price: item.price),
          ),
      ],
    );

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: widget.isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: AnimatedBuilder(
            animation: _shakeCtrl,
            builder: (context, child) => Transform.translate(offset: Offset(_shakeOffset(), 0), child: child),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: widget.isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, offset: const Offset(0, 2))],
                border: Border.all(color: widget.isSelected ? Colors.blue : Colors.transparent, width: 3),
              ),
              padding: const EdgeInsets.all(8.0),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final int price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '🪙 $price',
        style: TextStyle(
          color: cs.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
      ),
    );
  }
}
