import 'package:flutter/material.dart';
import 'package:tora_frontend/features/parent/models/parent_dashboard.dart';

class ParentKpisSection extends StatelessWidget {
  final ParentDashboard dashboard;
  const ParentKpisSection({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CompletedTasksCard(
            percentage: dashboard.summary.completedTasksPercentage,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _PanicButtonCard(count: dashboard.summary.panicButtonCount),
        ),
      ],
    );
  }
}

class _CompletedTasksCard extends StatelessWidget {
  final double percentage;

  const _CompletedTasksCard({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tareas Completadas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PanicButtonCard extends StatelessWidget {
  final int count;

  const _PanicButtonCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Uso Botón Pánico',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
