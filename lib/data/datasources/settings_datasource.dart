import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';

class SettingsDataSource {
  static const String _keyDailyGoal = 'daily_step_goal';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyUnit = 'unit';

  final SharedPreferences _prefs;

  SettingsDataSource(this._prefs);

  Future<AppSettings> getSettings() async {
    final dailyGoal = _prefs.getInt(_keyDailyGoal) ?? 10000;
    
    final themeModeStr = _prefs.getString(_keyThemeMode) ?? ThemeModeOption.system.name;
    final themeMode = ThemeModeOption.values.firstWhere(
      (e) => e.name == themeModeStr,
      orElse: () => ThemeModeOption.system,
    );

    final unitStr = _prefs.getString(_keyUnit) ?? UnitOption.metric.name;
    final unit = UnitOption.values.firstWhere(
      (e) => e.name == unitStr,
      orElse: () => UnitOption.metric,
    );

    return AppSettings(
      dailyStepGoal: dailyGoal,
      themeMode: themeMode,
      unit: unit,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setInt(_keyDailyGoal, settings.dailyStepGoal);
    await _prefs.setString(_keyThemeMode, settings.themeMode.name);
    await _prefs.setString(_keyUnit, settings.unit.name);
  }
}
