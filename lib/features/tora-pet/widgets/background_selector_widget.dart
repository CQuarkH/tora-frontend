import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/tora-pet/models/background.dart';
import 'package:tora_frontend/features/tora-pet/services/mascota_state.dart';

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
