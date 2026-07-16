import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../bloc/settings_bloc/settings_state.dart';
import '../bloc/step_bloc/step_bloc.dart';
import '../bloc/step_bloc/step_state.dart';
import '../widgets/step_graph_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is! SettingsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return BlocBuilder<StepBloc, StepState>(
          builder: (context, stepState) {
            if (stepState is! StepLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: StepGraphWidget(
                      weeklySteps: stepState.weeklySteps,
                      dailyGoal: settingsState.settings.dailyStepGoal,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
