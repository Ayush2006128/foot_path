import 'package:equatable/equatable.dart';

enum ThemeModeOption { system, light, dark }
enum UnitOption { metric, imperial }

class AppSettings extends Equatable {
  final int dailyStepGoal;
  final ThemeModeOption themeMode;
  final UnitOption unit;

  const AppSettings({
    required this.dailyStepGoal,
    required this.themeMode,
    required this.unit,
  });

  int get weeklyStepGoal => dailyStepGoal * 7;

  AppSettings copyWith({
    int? dailyStepGoal,
    ThemeModeOption? themeMode,
    UnitOption? unit,
  }) {
    return AppSettings(
      dailyStepGoal: dailyStepGoal ?? this.dailyStepGoal,
      themeMode: themeMode ?? this.themeMode,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [dailyStepGoal, themeMode, unit];
}
