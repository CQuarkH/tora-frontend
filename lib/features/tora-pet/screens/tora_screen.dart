// lib/features/tora-pet/screens/tora_screen.dart (guards de carga)
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:tora_frontend/features/tora-pet/services/mascota_state.dart';
import 'package:tora_frontend/features/tora-pet/widgets/accessory_selector_widget.dart';
import 'package:tora_frontend/features/tora-pet/widgets/background_selector_widget.dart';

class ToraScreen extends HookWidget {
  const ToraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mascotaState = context.watch<MascotaState>();

    // ⛑️ Evita “Bad state: No element” mientras carga
    if (!mascotaState.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackgroundSelector(mascotaState: mascotaState),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: MascotaCanvas(mascotaState: mascotaState),
              ),
            ),
            const SizedBox(height: 30),

            const Text('Selecciona el Sombrero:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            AccessorySelector(
              items: mascotaState.availableHats,
              currentId: mascotaState.currentHatId,
              onSelect: mascotaState.changeHat,
              onBuy: (acc) => mascotaState.buyHat(acc.id),
            ),
            const SizedBox(height: 20),

            const Text('Selecciona los Lentes:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            AccessorySelector(
              items: mascotaState.availableGlasses,
              currentId: mascotaState.currentGlassesId,
              onSelect: mascotaState.changeGlasses,
              onBuy: (acc) => mascotaState.buyGlasses(acc.id),
            ),
          ],
        ),
      ),
    );
  }
}

class MascotaCanvas extends HookWidget {
  final MascotaState mascotaState;
  const MascotaCanvas({required this.mascotaState, super.key});

  @override
  Widget build(BuildContext context) {
    useListenable(mascotaState);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackWidth = constraints.maxWidth;
        final stackHeight = constraints.maxHeight;

        const toraBaseWidthPercentage = 0.80;
        final toraBaseWidth = stackWidth * toraBaseWidthPercentage;
        final toraBaseLeft = stackWidth * (1 - toraBaseWidthPercentage) / 2;

        final hatAdj = mascotaState.currentHatAdjustment;
        final hatWidth = stackWidth * hatAdj.widthPercentage;
        final hatLeft = stackWidth * hatAdj.leftPercentage;
        final hatTop = stackHeight * hatAdj.topPercentage;

        final glassesAdj = mascotaState.currentGlassesAdjustment;
        final glassesWidth = stackWidth * glassesAdj.widthPercentage;
        final glassesLeft = stackWidth * glassesAdj.leftPercentage;
        final glassesTop = stackHeight * glassesAdj.topPercentage;

        final hatPath = mascotaState.currentHatPath;
        final glassesPath = mascotaState.currentGlassesPath;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (mascotaState.currentBackgroundId != 'none' &&
                mascotaState.currentBackgroundPath != null)
              Positioned.fill(
                child: Image.asset(
                  mascotaState.currentBackgroundPath!,
                  fit: BoxFit.cover,
                ),
              ),
            Positioned(
              left: toraBaseLeft,
              bottom: 0,
              width: toraBaseWidth,
              child: Image.asset(
                'assets/images/tora/tora_base.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: hatLeft,
              top: hatTop,
              width: hatWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: (mascotaState.currentHatId == 'none' || hatPath == null)
                    ? const SizedBox.shrink(key: ValueKey('no_hat'))
                    : Image.asset(
                        hatPath,
                        key: ValueKey(mascotaState.currentHatId),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              left: glassesLeft,
              top: glassesTop,
              width: glassesWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: (mascotaState.currentGlassesId == 'none' || glassesPath == null)
                    ? const SizedBox.shrink(key: ValueKey('no_glasses'))
                    : Image.asset(
                        glassesPath,
                        key: ValueKey(mascotaState.currentGlassesId),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
