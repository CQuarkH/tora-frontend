import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/child/models/task.dart';
import 'package:tora_frontend/features/child/services/calendar_service.dart';
import 'package:tora_frontend/features/child/widgets/period_selector_section.dart';
import 'package:tora_frontend/features/child/widgets/emotion_selector_section.dart';
import 'package:tora_frontend/features/child/widgets/tasks_section.dart';
import 'package:tora_frontend/features/child/widgets/timers_section.dart';

class ChildDayDetailScreen extends HookWidget {
  const ChildDayDetailScreen({super.key});

  // 🇨🇱 Obtener fecha y hora actual en zona horaria de Chile
  static DateTime _getChileDateTime() {
    final chile = tz.getLocation('America/Santiago');
    return tz.TZDateTime.now(chile);
  }

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = useState<Period>(Period.MORNING);
    final chileNow = useMemoized(
      () => _getChileDateTime(),
    ); // 👈 Calcular una vez

    final currentCalendar = useState<Calendar>(
      Calendar(
        id: '',
        childId: '',
        date: chileNow, // 👈 Usar hora de Chile
        blocks: [],
      ),
    );

    // 👇 Inicializar timezone en el primer render
    useEffect(() {
      tz.initializeTimeZones();
      return null;
    }, []);

    useEffect(() {
      Future.microtask(() async {
        final authService = AuthService();
        final user = await authService.getCurrentUser();

        // 👇 Usar la fecha de Chile para obtener el calendario
        final calendar = await CalendarService.getDailyCalendar(
          childId: user!.id,
          date: chileNow,
        );
        currentCalendar.value = calendar;
      });
      return null;
    }, [chileNow]); // 👈 Dependencia de chileNow

    // Obtener el bloque actual basado en el período seleccionado
    final currentBlock = useMemoized(() {
      return currentCalendar.value.blocks.firstWhere(
        (block) => block.period == selectedPeriod.value,
        orElse: () => CalendarBlock(
          id: chileNow.millisecondsSinceEpoch
              .toString(), // 👈 Usar hora de Chile
          calendarId: currentCalendar.value.id,
          period: selectedPeriod.value,
          tasks: [],
        ),
      );
    }, [currentCalendar.value, selectedPeriod.value]);

    // Función para actualizar el calendario con un bloque modificado
    void updateCalendarWithBlock(CalendarBlock updatedBlock) {
      final updatedBlocks = currentCalendar.value.blocks.map((block) {
        if (block.period == updatedBlock.period) {
          return updatedBlock;
        }
        return block;
      }).toList();

      // Si el bloque no existía, lo agregamos
      if (!updatedBlocks.any((block) => block.period == updatedBlock.period)) {
        updatedBlocks.add(updatedBlock);
      }

      currentCalendar.value = Calendar(
        id: currentCalendar.value.id,
        childId: currentCalendar.value.childId,
        date: currentCalendar.value.date,
        blocks: updatedBlocks,
      );
    }

    // Función para toggle de tareas
    Future<void> toggleTask(String taskId) async {
      final task = currentBlock.tasks.firstWhere((t) => t.id == taskId);
      final newStatus = task.status == TaskStatus.PENDING
          ? TaskStatus.DONE
          : TaskStatus.PENDING;

      try {
        final updatedTask = await CalendarService.updateTask(
          taskId: taskId,
          updateData: {'status': newStatus.name},
        );

        final updatedTasks = currentBlock.tasks.map((t) {
          return t.id == taskId ? updatedTask : t;
        }).toList();

        final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
        updateCalendarWithBlock(updatedBlock);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar tarea: $e')),
        );
      }
    }

    // Función para agregar nueva tarea
    Future<void> addTask(String title, String description) async {
      try {
        final newTask = await CalendarService.addTaskToBlock(
          blockId: currentBlock.id,
          title: title,
          description: description,
        );

        final updatedTasks = [...currentBlock.tasks, newTask];
        final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
        updateCalendarWithBlock(updatedBlock);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al agregar tarea: $e')));
      }
    }

    Future<void> deleteTask(String taskId) async {
      try {
        await CalendarService.deleteTask(taskId);
        final updatedTasks = currentBlock.tasks
            .where((task) => task.id != taskId)
            .toList();
        final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
        updateCalendarWithBlock(updatedBlock);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar tarea: $e')));
      }
    }

    // Función para registrar emoción
    Future<void> recordEmotion(Emotion emotion) async {
      try {
        final record = await CalendarService.recordEmotion(
          blockId: currentBlock.id,
          emotion: emotion,
        );

        final updatedBlock = currentBlock.copyWith(emotion: record);
        updateCalendarWithBlock(updatedBlock);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar emoción: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Organizador - ${currentCalendar.value.date.day}/${currentCalendar.value.date.month}/${currentCalendar.value.date.year}',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de período
              PeriodSelectorSection(
                selectedPeriod: selectedPeriod.value,
                onPeriodChanged: (period) => selectedPeriod.value = period,
              ),

              const SizedBox(height: 20.0),

              // Selector de emociones
              EmotionSelectorSection(
                currentEmotion: currentBlock.emotion,
                onEmotionSelected: recordEmotion,
              ),

              const SizedBox(height: 20.0),

              // Sección de tareas
              TasksSection(
                currentBlock: currentBlock,
                onTaskToggle: toggleTask,
                onTaskAdd: addTask,
                onTaskDelete: deleteTask,
              ),

              const SizedBox(height: 20.0),

              // Información del período
              TimersSection(),

              const SizedBox(
                height: 80.0,
              ), // Espacio para evitar solapamiento con el FAB
            ],
          ),
        ),
      ),
    );
  }
}
