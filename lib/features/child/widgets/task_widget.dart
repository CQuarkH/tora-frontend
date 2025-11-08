// lib/features/child/widgets/task_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tora_frontend/core/widgets/alert_win_coins_helper.dart';
import 'package:tora_frontend/core/widgets/show_confirm_task_dialog.dart';
import 'package:tora_frontend/features/child/models/task.dart';

/// Widget de Tarea con anti-spam:
/// - Cooldown entre taps (front-only).
/// - Diálogo de confirmación opcional.
/// - Feedback visual (loader / badge) y SnackBars.
class TaskWidget extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle; // Marca como completada (o invierte estado)
  final VoidCallback? onDelete; // Eliminar
  final Duration cooldown; // Tiempo mínimo entre confirmaciones
  final bool requireConfirm; // Pregunta antes de completar
  final String confirmTitle;
  final String confirmMessage;
  final int? rewardCoins; // Solo para mostrar en feedback

  const TaskWidget({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
    this.cooldown = const Duration(seconds: 2),
    this.requireConfirm = true,
    this.confirmTitle = '¿Marcar como completada?',
    this.confirmMessage = 'Confirmar que realizaste esta tarea.',
    this.rewardCoins,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool _busy = false;
  DateTime? _lastActionAt;
  Timer? _ticker; // para refrescar el badge del cooldown

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  bool get _isDone => widget.task.status == TaskStatus.DONE;

  bool _inCooldown() {
    if (_lastActionAt == null) return false;
    return DateTime.now().difference(_lastActionAt!) < widget.cooldown;
  }

  int _cooldownLeftSeconds() {
    if (_lastActionAt == null) return 0;
    final left = widget.cooldown - DateTime.now().difference(_lastActionAt!);
    return left.isNegative ? 0 : (left.inMilliseconds / 1000).ceil();
  }

  Future<void> _handleTap() async {
    if (_busy) return;

    if (_isDone) {
      _showSnack('Esta tarea ya está completada.');
      return;
    }

    if (_inCooldown()) {
      _showSnack('Espera ${_cooldownLeftSeconds()} s para volver a intentar.');
      return;
    }

    if (widget.requireConfirm) {
      final ok = await showConfirmTaskDialog(
        context,
        taskTitle: widget.task.title,
      
        imageAsset: 'assets/images/tora/tora_task_confirm.png',
        confirmText: '🎒 ¡Tarea lista!',
      );

      if (ok != true) return;
    }

    

    setState(() => _busy = true);
    try {
      // Marca como completada (tu lógica la maneja el callback)
      await Future.sync(widget.onToggle);

      // Feedback
      HapticFeedback.mediumImpact();
      final coins = widget.rewardCoins;
      _showSnack(
        coins != null ? '¡Tarea completada! +$coins 🪙' : '¡Tarea completada!',
      );

      // Inicia cooldown y ticker para badge
      _lastActionAt = DateTime.now();
      _startTicker();
    } catch (e) {
      _showSnack('No se pudo completar: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    // Refresca cada 200ms mientras haya cooldown
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (!_inCooldown()) {
        t.cancel();
      }
      if (mounted) setState(() {});
    });
  }

  void _showSnack(String msg) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: cs.primary,
          content: Text(msg, style: TextStyle(color: cs.onPrimary)),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _isDone;
    final inCd = _inCooldown();

    return Stack(
      children: [
        Opacity(
          opacity: (_busy || inCd) ? 0.95 : 1,
          child: IgnorePointer(
            ignoring: _busy || inCd,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: isDone ? Colors.green[50] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isDone ? Colors.green[200]! : Colors.grey[200]!,
                  width: 1.0,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleTap,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Checkbox / Loader
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _busy
                              ? const SizedBox(
                                  key: ValueKey('loader'),
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Container(
                                  key: ValueKey(isDone),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone
                                        ? Colors.green
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isDone
                                          ? Colors.green
                                          : Colors.grey[400]!,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: isDone
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                        ),

                        const SizedBox(width: 12.0),

                        // Contenido
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task.title,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDone
                                      ? Colors.green[700]
                                      : Colors.black87,
                                ),
                              ),
                              if ((widget.task.description ?? '')
                                  .isNotEmpty) ...[
                                const SizedBox(height: 4.0),
                                Text(
                                  widget.task.description!,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: isDone
                                        ? Colors.green[600]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                              if (isDone && widget.task.startTime != null) ...[
                                const SizedBox(height: 4.0),
                                Text(
                                  'Completada: ${_formatTime(widget.task.startTime!)}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.green[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Menú
                        if (widget.onDelete != null)
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') widget.onDelete!.call();
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}


