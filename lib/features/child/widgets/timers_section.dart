// widgets/timers_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/timer.dart';
import '../services/timer_service.dart';

class TimersSection extends HookWidget {
  const TimersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = TimerService();

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, child) {
        final timers = timerService.timers.values.toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '⏱️ Temporizadores',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddTimerDialog(context),
                    icon: const Icon(Icons.add_alarm, color: Colors.blue),
                    tooltip: 'Agregar timer',
                  ),
                ],
              ),

              if (timers.isEmpty) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.timer_off, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'No hay timers activos',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _showAddTimerDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Crear primer timer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                ...timers.map(
                  (timer) => _TimerCard(
                    timer: timer,
                    onStart: () => timerService.startTimer(timer.id),
                    onPause: () => timerService.pauseTimer(timer.id),
                    onStop: () => timerService.stopTimer(timer.id),
                    onReset: () => timerService.resetTimer(timer.id),
                    onDelete: () => timerService.removeTimer(timer.id),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddTimerDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const _AddTimerDialog());
  }
}

class _TimerCard extends StatelessWidget {
  final TimerModel timer;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onReset;
  final VoidCallback onDelete;

  const _TimerCard({
    required this.timer,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    required this.onReset,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timer.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (timer.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          timer.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Barra de progreso
            LinearProgressIndicator(
              value: timer.progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                timer.status == TimerStatus.completed
                    ? Colors.green
                    : timer.status == TimerStatus.running
                    ? Colors.blue
                    : Colors.orange,
              ),
            ),

            const SizedBox(height: 12),

            // Tiempo y controles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timer.formattedRemainingTime,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: timer.status == TimerStatus.completed
                            ? Colors.green
                            : timer.status == TimerStatus.running
                            ? Colors.blue
                            : Colors.grey[700],
                      ),
                    ),
                    Text(
                      'de ${timer.formattedDuration}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (timer.status == TimerStatus.stopped ||
                        timer.status == TimerStatus.paused) ...[
                      IconButton(
                        onPressed: onStart,
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.green,
                        tooltip: 'Iniciar',
                      ),
                    ] else if (timer.status == TimerStatus.running) ...[
                      IconButton(
                        onPressed: onPause,
                        icon: const Icon(Icons.pause),
                        color: Colors.orange,
                        tooltip: 'Pausar',
                      ),
                    ],

                    if (timer.status != TimerStatus.stopped) ...[
                      IconButton(
                        onPressed: onStop,
                        icon: const Icon(Icons.stop),
                        color: Colors.red,
                        tooltip: 'Detener',
                      ),
                    ],

                    if (timer.status == TimerStatus.completed ||
                        (timer.status == TimerStatus.stopped &&
                            timer.remainingTime != timer.duration)) ...[
                      IconButton(
                        onPressed: onReset,
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                        tooltip: 'Reiniciar',
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Estado del timer
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getStatusColor(timer.status),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(timer.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(timer.status),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TimerStatus status) {
    switch (status) {
      case TimerStatus.stopped:
        return Colors.grey;
      case TimerStatus.running:
        return Colors.blue;
      case TimerStatus.paused:
        return Colors.orange;
      case TimerStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(TimerStatus status) {
    switch (status) {
      case TimerStatus.stopped:
        return 'Detenido';
      case TimerStatus.running:
        return 'En progreso';
      case TimerStatus.paused:
        return 'Pausado';
      case TimerStatus.completed:
        return '¡Completado!';
    }
  }
}

class _AddTimerDialog extends HookWidget {
  const _AddTimerDialog();

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final hours = useState(0);
    final minutes = useState(5);
    final seconds = useState(0);
    final hasSound = useState(true);
    final hasVibration = useState(true);

    return AlertDialog(
      title: const Text('Nuevo Timer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del timer',
                hintText: 'ej: Tiempo de estudio',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                hintText: 'ej: Estudiar matemáticas',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            const Text(
              'Duración:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Horas
                Column(
                  children: [
                    const Text('Horas'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () =>
                                hours.value = (hours.value + 1) % 24,
                            icon: const Icon(Icons.keyboard_arrow_up),
                          ),
                          Text(
                            hours.value.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                hours.value = (hours.value - 1) % 24,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Minutos
                Column(
                  children: [
                    const Text('Minutos'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () =>
                                minutes.value = (minutes.value + 1) % 60,
                            icon: const Icon(Icons.keyboard_arrow_up),
                          ),
                          Text(
                            minutes.value.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                minutes.value = (minutes.value - 1) % 60,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Segundos
                Column(
                  children: [
                    const Text('Segundos'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () =>
                                seconds.value = (seconds.value + 1) % 60,
                            icon: const Icon(Icons.keyboard_arrow_up),
                          ),
                          Text(
                            seconds.value.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                seconds.value = (seconds.value - 1) % 60,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Opciones de sonido y vibración
            CheckboxListTile(
              title: const Text('Sonido al finalizar'),
              value: hasSound.value,
              onChanged: (value) => hasSound.value = value ?? true,
              dense: true,
            ),

            CheckboxListTile(
              title: const Text('Vibración al finalizar'),
              value: hasVibration.value,
              onChanged: (value) => hasVibration.value = value ?? true,
              dense: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) return;

            final duration = Duration(
              hours: hours.value,
              minutes: minutes.value,
              seconds: seconds.value,
            );

            if (duration.inSeconds == 0) return;

            final timer = TimerModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              duration: duration,
              remainingTime: duration,
              status: TimerStatus.stopped,
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
              hasSound: hasSound.value,
              hasVibration: hasVibration.value,
            );

            TimerService().addTimer(timer);
            Navigator.of(context).pop();
          },
          child: const Text('Crear Timer'),
        ),
      ],
    );
  }
}
