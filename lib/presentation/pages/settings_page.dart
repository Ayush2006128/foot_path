import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../bloc/settings_bloc/settings_event.dart';
import '../bloc/settings_bloc/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme Mode'),
                trailing: DropdownButton<ThemeModeOption>(
                  value: settings.themeMode,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<SettingsBloc>().add(
                            UpdateSettings(settings.copyWith(themeMode: newValue)),
                          );
                    }
                  },
                  items: ThemeModeOption.values.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.name.toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: const Text('Units'),
                trailing: DropdownButton<UnitOption>(
                  value: settings.unit,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<SettingsBloc>().add(
                            UpdateSettings(settings.copyWith(unit: newValue)),
                          );
                    }
                  },
                  items: UnitOption.values.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit.name.toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Daily Step Goal'),
                subtitle: Text('${settings.dailyStepGoal} steps'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showGoalEditDialog(context, settings);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.auto_graph),
                title: const Text('Weekly Step Goal'),
                subtitle: Text('${settings.weeklyStepGoal} steps (Auto-calculated)'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showGoalEditDialog(BuildContext context, AppSettings settings) async {
    final controller = TextEditingController(text: settings.dailyStepGoal.toString());
    
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Daily Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Steps'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newGoal = int.tryParse(controller.text);
                if (newGoal != null && newGoal > 0) {
                  context.read<SettingsBloc>().add(
                        UpdateSettings(settings.copyWith(dailyStepGoal: newGoal)),
                      );
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
