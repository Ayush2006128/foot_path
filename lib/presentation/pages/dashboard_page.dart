import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/calculations.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../bloc/settings_bloc/settings_state.dart';
import '../bloc/step_bloc/step_bloc.dart';
import '../bloc/step_bloc/step_event.dart';
import '../bloc/step_bloc/step_state.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/stats_card_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final settings = settingsState.settings;

        return BlocBuilder<StepBloc, StepState>(
          builder: (context, stepState) {
            if (stepState is StepLoading || stepState is StepInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (stepState is StepError) {
              return Center(child: Text('Error: ${stepState.message}'));
            }

            final state = stepState as StepLoaded;
            final steps = state.currentSteps;
            final isTracking = state.isTracking;

            final distance = settings.unit == UnitOption.metric
                ? Calculations.calculateDistanceKm(steps)
                : Calculations.calculateDistanceMiles(steps);
            final distanceUnit = settings.unit == UnitOption.metric ? 'km' : 'mi';
            final calories = Calculations.calculateCalories(steps);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircularProgressWidget(
                      steps: steps,
                      goal: settings.dailyStepGoal,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: StatsCardWidget(
                            title: 'Distance ($distanceUnit)',
                            value: distance.toStringAsFixed(2),
                            icon: Icons.map_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsCardWidget(
                            title: 'Calories (kcal)',
                            value: calories.toStringAsFixed(0),
                            icon: Icons.local_fire_department_outlined,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<StepBloc>().add(ToggleTracking());
                      },
                      icon: Icon(isTracking ? Icons.stop_circle : Icons.play_circle),
                      label: Text(isTracking ? 'Stop Tracking' : 'Start Tracking'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: isTracking ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
