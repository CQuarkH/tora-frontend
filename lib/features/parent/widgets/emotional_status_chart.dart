import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:fl_chart/fl_chart.dart';

class EmotionalStatusChart extends StatelessWidget {
  final List<EmotionRecord> emotions;

  const EmotionalStatusChart({super.key, required this.emotions});

  Map<Emotion, int> _getEmotionCounts() {
    final Map<Emotion, int> emotionCounts = {};

    for (var record in emotions) {
      emotionCounts[record.emotion] = (emotionCounts[record.emotion] ?? 0) + 1;
    }

    return emotionCounts;
  }

  List<MapEntry<Emotion, int>> _getTopEmotions() {
    final emotionCounts = _getEmotionCounts();
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Retornar máximo 5 emociones
    return sortedEmotions.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topEmotions = _getTopEmotions();

    if (topEmotions.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado Emocional',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No hay emociones registradas',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    // Encontrar el máximo valor para escalar
    final maxCount = topEmotions.first.value.toDouble();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Estado Emocional',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Top ${topEmotions.length} emociones más frecuentes',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount + (maxCount * 0.2), // 20% más para padding
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final emotion = topEmotions[groupIndex].key;
                      final count = topEmotions[groupIndex].value;
                      return BarTooltipItem(
                        '${emotion.displayName}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '$count veces',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= topEmotions.length) {
                          return const SizedBox.shrink();
                        }
                        final emotion = topEmotions[value.toInt()].key;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Text(
                                emotion.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${topEmotions[value.toInt()].value}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(topEmotions.length, (index) {
                  final emotion = topEmotions[index].key;
                  final count = topEmotions[index].value.toDouble();

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count,
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.3),
                          width: 0.5,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            emotion.backgroundColor.withOpacity(0.8),
                            emotion.backgroundColor,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 35,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
