import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'mascota_state.dart';

class ToraScreen extends HookWidget {
  const ToraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mascotaState = useMemoized(() => MascotaState(), []);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // títulos a la izquierda
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

         

            // Selector de sombreros
            const Text(
              'Selecciona el Sombrero:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            HatButtonSelector(mascotaState: mascotaState),
            const SizedBox(height: 20),

            // Selector de lentes
            const Text(
              'Selecciona los Lentes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GlassesButtonSelector(mascotaState: mascotaState),
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
        final double stackWidth = constraints.maxWidth;
        final double stackHeight = constraints.maxHeight;

        // --- IMAGEN BASE ---
        const double toraBaseWidthPercentage = 0.80;
        final double toraBaseWidth = stackWidth * toraBaseWidthPercentage;
        final double toraBaseLeft =
            stackWidth * (1 - toraBaseWidthPercentage) / 2;

        // --- AJUSTE DE SOMBRERO ---
        final hatAdj = mascotaState.currentHatAdjustment;
        final double hatWidth = stackWidth * hatAdj.widthPercentage;
        final double hatLeft = stackWidth * hatAdj.leftPercentage;
        final double hatTop = stackHeight * hatAdj.topPercentage;

        // --- AJUSTE DE LENTES ---
        final glassesAdj = mascotaState.currentGlassesAdjustment;
        final double glassesWidth = stackWidth * glassesAdj.widthPercentage;
        final double glassesLeft = stackWidth * glassesAdj.leftPercentage;
        final double glassesTop = stackHeight * glassesAdj.topPercentage;

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            // Fondo
            if (mascotaState.currentBackgroundId != 'none' &&
                mascotaState.currentBackgroundPath != null)
              Positioned.fill(
                child: Image.asset(
                  mascotaState.currentBackgroundPath!,
                  fit: BoxFit.cover,
                ),
              ),

            // Base
            Positioned(
              left: toraBaseLeft,
              bottom: 0,
              width: toraBaseWidth,
              child: Image.asset(
                'assets/images/tora/tora_base.png',
                fit: BoxFit.contain,
              ),
            ),

            // Sombrero animado 🎩
            Positioned(
              left: hatLeft,
              top: hatTop,
              width: hatWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale:
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: mascotaState.currentHatId == 'none' ||
                        mascotaState.currentHatPath == null
                    ? const SizedBox.shrink(key: ValueKey('no_hat'))
                    : Image.asset(
                        mascotaState.currentHatPath!,
                        key: ValueKey(mascotaState.currentHatId),
                        fit: BoxFit.contain,
                      ),
              ),
            ),

            // Lentes animados 😎
            Positioned(
              left: glassesLeft,
              top: glassesTop,
              width: glassesWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale:
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: mascotaState.currentGlassesId == 'none' ||
                        mascotaState.currentGlassesPath == null
                    ? const SizedBox.shrink(key: ValueKey('no_glasses'))
                    : Image.asset(
                        mascotaState.currentGlassesPath!,
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

// ------------------------------------------------------------
// SELECTOR DE SOMBREROS
// ------------------------------------------------------------
class HatButtonSelector extends HookWidget {
  final MascotaState mascotaState;
  const HatButtonSelector({required this.mascotaState, super.key});

  @override
  Widget build(BuildContext context) {
    useListenable(mascotaState);
    return AccessorySelector(
      items: availableHats,
      currentId: mascotaState.currentHatId,
      onSelect: mascotaState.changeHat,
    );
  }
}

// ------------------------------------------------------------
// SELECTOR DE LENTES
// ------------------------------------------------------------
class GlassesButtonSelector extends HookWidget {
  final MascotaState mascotaState;
  const GlassesButtonSelector({required this.mascotaState, super.key});

  @override
  Widget build(BuildContext context) {
    useListenable(mascotaState);
    return AccessorySelector(
      items: availableGlasses,
      currentId: mascotaState.currentGlassesId,
      onSelect: mascotaState.changeGlasses,
    );
  }
}

// ------------------------------------------------------------
// COMPONENTE REUTILIZABLE PARA SELECCIÓN DE ACCESORIOS
// ------------------------------------------------------------
class AccessorySelector extends StatelessWidget {
  final List<Accessory> items;
  final String currentId;
  final void Function(String) onSelect;

  const AccessorySelector({
    required this.items,
    required this.currentId,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: items.map((item) {
          final isSelected = item.id == currentId;

          Widget content;
          if (item.id == 'none') {
            content = const Center(
              child: Text(
                'NONE',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            content = Image.asset(item.path, fit: BoxFit.contain);
          }

          return GestureDetector(
            onTap: () async {
              onSelect(item.id);
              
              await player.play(AssetSource('sounds/pop.mp3'));
            },
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 3,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: content,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ------------------------------------------------------------
// SELECTOR DE FONDOS
// ------------------------------------------------------------
class BackgroundSelector extends HookWidget {
  final MascotaState mascotaState;
  const BackgroundSelector({required this.mascotaState, super.key});

  @override
  Widget build(BuildContext context) {
    useListenable(mascotaState);

    return DropdownButton<String>(
      value: mascotaState.currentBackgroundId,
      items: availableBackgrounds.map((bg) {
        return DropdownMenuItem<String>(
          value: bg.id,
          child: Text(bg.name),
        );
      }).toList(),
      onChanged: (String? newId) {
        if (newId != null) {
          mascotaState.changeBackground(newId);
        }
      },
    );
  }
}
