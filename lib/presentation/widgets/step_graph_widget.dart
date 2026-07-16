import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/daily_steps.dart';

class StepGraphWidget extends StatelessWidget {
  final List<DailySteps> weeklySteps;
  final int dailyGoal;

  const StepGraphWidget({
    super.key,
    required this.weeklySteps,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (weeklySteps.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Sort steps to ensure chronological order for the graph (oldest first)
    final sortedSteps = List<DailySteps>.from(weeklySteps)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (dailyGoal * 1.5).toDouble(), // some headroom
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => theme.colorScheme.primaryContainer,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} steps\n',
                          theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat('E, MMM d').format(sortedSteps[group.x.toInt()].date),
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
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
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final date = sortedSteps[value.toInt()].date;
                          final text = DateFormat('E').format(date);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              text,
                              style: theme.textTheme.bodySmall,
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
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: dailyGoal / 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    sortedSteps.length,
                    (index) {
                      final steps = sortedSteps[index].steps.toDouble();
                      final isToday = index == sortedSteps.length - 1;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: steps,
                            color: isToday ? theme.colorScheme.primary : theme.colorScheme.secondary,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: dailyGoal.toDouble(),
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
