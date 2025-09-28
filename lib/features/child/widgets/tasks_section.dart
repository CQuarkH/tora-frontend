import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/task.dart';
import 'package:tora_frontend/features/child/widgets/task_widget.dart';
import 'package:tora_frontend/features/child/widgets/add_task_dialog.dart';

class TasksSection extends StatelessWidget {
  final CalendarBlock currentBlock;
  final ValueChanged<String> onTaskToggle;
  final Function(String, String) onTaskAdd;
  final ValueChanged<String> onTaskDelete;

  const TasksSection({
    super.key,
    required this.currentBlock,
    required this.onTaskToggle,
    required this.onTaskAdd,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks = currentBlock.tasks
        .where((task) => task.status == TaskStatus.DONE)
        .length;
    final totalTasks = currentBlock.tasks.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header de tareas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Mis Tareas',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '($completedTasks/$totalTasks)',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Organiza tu día en tareas',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _showAddTaskDialog(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Agregar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Barra de progreso
          if (totalTasks > 0) ...[
            LinearProgressIndicator(
              value: completedTasks / totalTasks,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                completedTasks == totalTasks ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(height: 16.0),
          ],

          // Lista de tareas
          if (currentBlock.tasks.isEmpty)
            _buildEmptyState()
          else
            ...currentBlock.tasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TaskWidget(
                  task: task,
                  onToggle: () => onTaskToggle(task.id),
                  onDelete: () => _showDeleteConfirmation(context, task.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12.0),
          Text(
            'No hay tareas para este momento',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Agrega tu primera tarea para comenzar',
            style: TextStyle(color: Colors.grey[400], fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(onTaskAdded: onTaskAdd),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta tarea?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onTaskDelete(taskId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
