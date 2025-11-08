// lib/features/tora-pet/widgets/coin_reward_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tora_frontend/features/tora-pet/services/coins_state.dart';

Future<void> showCoinRewardDialog(
  BuildContext context, {
  required int coinsWon,
  String? message,
  VoidCallback? onClaimed, 
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _CoinRewardDialog(
      coinsWon: coinsWon,
      message: message,
      onClaimed: onClaimed,
    ),
  );
}

class _CoinRewardDialog extends StatefulWidget {
  final int coinsWon;
  final String? message;
  final VoidCallback? onClaimed;

  const _CoinRewardDialog({
    super.key,
    required this.coinsWon,
    this.message,
    this.onClaimed,
  });

  @override
  State<_CoinRewardDialog> createState() => _CoinRewardDialogState();
}

class _CoinRewardDialogState extends State<_CoinRewardDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _claimCoins() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    // Captura la instancia ANTES de cerrar el diálogo.
    final coins = context.read<CoinsState>();
    final cs = Theme.of(context).colorScheme;

    try {
      await coins.add(widget.coinsWon); // actualiza provider + backend
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: cs.secondary,
            content: Text('¡+${widget.coinsWon} 🪙 acreditados!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            duration: const Duration(seconds: 2),
          ),
        );

      Navigator.of(context).pop();

      widget.onClaimed?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: cs.error,
            content: Text('No se pudo acreditar: $e'),
          ),
        );
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 340;
    final isTiny = size.width < 300;
    final scaled = MediaQuery.of(context).textScaler.scale(isTiny ? 0.85 : (isNarrow ? 0.92 : 1.0));

    return Dialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        child: MediaQuery(
          // Escala de texto compacta SOLO en este diálogo
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scaled)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header con cerrar
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '¡Recompensa!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    IconButton(
                      onPressed: _submitting ? null : () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: cs.onSurface),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Imagen
                SizedBox(
                  width: math.min(size.width * 0.6, 220),
                  height: math.min(size.width * 0.6, 220),
                  child: Image.asset('assets/images/tora/tora_slot_machine.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),

                // Mensaje adaptativo
                Text(
                  widget.message ?? '¡Felicidades!',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // Banner animado de recompensa
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.shade700, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events, color: Colors.amber.shade800, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '¡Ganaste ${widget.coinsWon} 🪙!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botones
                Row(
                  children: [
                   
                
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: cs.primary,
                        ),
                        onPressed: _submitting ? null : _claimCoins,
                        child: _submitting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text('Cobrar', style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
