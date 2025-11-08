// lib/features/tora-pet/widgets/coins_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tora_frontend/features/tora-pet/services/coins_state.dart';

class CoinsWidget extends HookWidget {
  const CoinsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final coinsState = context.watch<CoinsState>(); 

    // Carga inicial una sola vez
    useEffect(() {
      coinsState.ensureLoaded();
      return null;
    }, [coinsState]);

    final int value = coinsState.coins ?? 0;
    final bool loading = coinsState.isLoading && coinsState.coins == null;

    if (loading) {
      return const SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono
          SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('assets/images/tora/tora_coin.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 6),
          // Valor con animación
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
            ),
          ),
          // Spinner pequeño si está actualizando en segundo plano
          if (coinsState.isLoading) ...[
            const SizedBox(width: 6),
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
