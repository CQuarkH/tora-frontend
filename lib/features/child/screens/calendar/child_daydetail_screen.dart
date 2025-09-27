import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/child/models/task.dart';
import 'package:tora_frontend/features/child/widgets/period_selector_section.dart';
import 'package:tora_frontend/features/child/widgets/emotion_selector_section.dart';
import 'package:tora_frontend/features/child/widgets/tasks_section.dart';
import 'package:tora_frontend/features/child/widgets/timers_section.dart';

class ChildDayDetailScreen extends HookWidget {
  final Child currentChild;
  final Calendar todayCalendar;

  const ChildDayDetailScreen({
    super.key,
    required this.currentChild,
    required this.todayCalendar,
  });

  @override
  Widget build(BuildContext context) {
    // Estados usando hooks
    final selectedPeriod = useState<Period>(Period.MORNING);
    final currentCalendar = useState<Calendar>(todayCalendar);

    // Obtener el bloque actual basado en el período seleccionado
    final currentBlock = useMemoized(() {
      return currentCalendar.value.blocks.firstWhere(
        (block) => block.period == selectedPeriod.value,
        orElse: () => CalendarBlock(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
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
    void toggleTask(String taskId) {
      final updatedTasks = currentBlock.tasks.map((task) {
        if (task.id == taskId) {
          final newStatus = task.status == TaskStatus.PENDING
              ? TaskStatus.DONE
              : TaskStatus.PENDING;
          return task.copyWith(
            status: newStatus,
            startTime: newStatus == TaskStatus.DONE ? DateTime.now() : null,
            endTime: newStatus == TaskStatus.DONE ? DateTime.now() : null,
          );
        }
        return task;
      }).toList();

      final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
      updateCalendarWithBlock(updatedBlock);
    }

    // Función para agregar nueva tarea
    void addTask(String title, String description) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        blockId: currentBlock.id,
        title: title,
        description: description,
        status: TaskStatus.PENDING,
        createdAt: DateTime.now(),
      );

      final updatedTasks = [...currentBlock.tasks, newTask];
      final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
      updateCalendarWithBlock(updatedBlock);
    }

    // Función para eliminar tarea
    void deleteTask(String taskId) {
      final updatedTasks = currentBlock.tasks
          .where((task) => task.id != taskId)
          .toList();

      final updatedBlock = currentBlock.copyWith(tasks: updatedTasks);
      updateCalendarWithBlock(updatedBlock);
    }

    // Función para registrar emoción
    void recordEmotion(Emotion emotion) {
      final emotionRecord = EmotionRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        blockId: currentBlock.id,
        emotion: emotion,
        createdAt: DateTime.now(),
      );

      final updatedBlock = currentBlock.copyWith(emotion: emotionRecord);
      updateCalendarWithBlock(updatedBlock);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          '${currentChild.name} - ${currentCalendar.value.date.day}/${currentCalendar.value.date.month}/${currentCalendar.value.date.year}',
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
            ],
          ),
        ),
      ),
    );
  }
}
