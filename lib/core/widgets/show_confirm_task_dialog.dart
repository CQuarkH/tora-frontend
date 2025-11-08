// lib/features/child/widgets/confirm_task_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tora_frontend/features/tora-pet/services/coins_state.dart';

Future<bool?> showConfirmTaskDialog(
  BuildContext context, {
  required String taskTitle,
  String imageAsset = 'assets/images/tora/tora_task_confirm.png',
  String confirmText = 'Confirmar',
  String cancelText = 'Cancelar',
  int coinsToAward = 100,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _ConfirmTaskDialog(
      taskTitle: taskTitle,
      imageAsset: imageAsset,
      confirmText: confirmText,
      cancelText: cancelText,
      coinsToAward: coinsToAward,
    ),
  );
}

class _ConfirmTaskDialog extends StatefulWidget {
  final String taskTitle;
  final String imageAsset;
  final String confirmText;
  final String cancelText;
  final int coinsToAward;

  const _ConfirmTaskDialog({
    super.key,
    required this.taskTitle,
    required this.imageAsset,
    required this.confirmText,
    required this.cancelText,
    required this.coinsToAward,
  });

  @override
  State<_ConfirmTaskDialog> createState() => _ConfirmTaskDialogState();
}

class _ConfirmTaskDialogState extends State<_ConfirmTaskDialog>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  bool _submitting = false;
  bool _done = false;

  static const double kButtonsAreaHeight = 56;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, .06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeIn);
    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmAndAward() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    try {
      await context.read<CoinsState>().add(widget.coinsToAward);
      if (!mounted) return;

      setState(() {
        _done = true; // muestra recompensa
        _submitting = false;
      });

      await Future<void>.delayed(const Duration(milliseconds: 2500));  // espera un momento y luego cierra
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: cs.error,
            content: Text('No se pudo acreditar: $e'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 340;
    final isTiny = size.width < 300;
    final scaled = MediaQuery.of(
      context,
    ).textScaler.scale(isTiny ? 0.85 : (isNarrow ? 0.92 : 1.0));

    return Dialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scaled)),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (c, a) =>
                                  FadeTransition(opacity: a, child: c),
                              child: Text(
                                _done
                                    ? '¡Listo!'
                                    : 'Tarea: ${widget.taskTitle}',
                                key: ValueKey(_done ? 'done' : 'ask'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _submitting
                                ? null
                                : () => Navigator.of(context).pop(_done),
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
                        child: Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cuerpo con transición suave
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.98,
                              end: 1,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _done
                            ? Column(
                                key: const ValueKey('reward_view'),
                                children: [
                                  Text(
                                    '¡Por completar tu tarea queremos recompensarte!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.amber.shade700,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber.shade800,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '¡Ganaste ${widget.coinsToAward} 🪙!',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : TaskConfirmationMessage()
                      ),

                      const SizedBox(height: 16),

                      // Área de botones con alto fijo (no se encoge al ocultar)
                      SizedBox(
                        height: kButtonsAreaHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: IgnorePointer(
                                ignoring: _done || _submitting,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 180),
                                  opacity: _done ? 0 : 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: _submitting
                                              ? null
                                              : () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: cs.primary,
                                          ),
                                          onPressed: _submitting
                                              ? null
                                              : _confirmAndAward,
                                          child: _submitting
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : Text(
                                                  'Confirmar',
                                                  style: TextStyle(
                                                    color: cs.onPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class TaskConfirmationMessage extends StatefulWidget {
  const TaskConfirmationMessage({super.key});

  @override
  State<TaskConfirmationMessage> createState() => _TaskConfirmationMessageState();
}

class _TaskConfirmationMessageState extends State<TaskConfirmationMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "¿Terminaste esta tarea?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 12),
        ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              "¡Muy bien! 🎉",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
