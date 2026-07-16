import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final int steps;
  final int goal;

  const CircularProgressWidget({
    super.key,
    required this.steps,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (steps / goal).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 15,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.primary,
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk, size: 40, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              steps.toString(),
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '/ $goal steps',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
