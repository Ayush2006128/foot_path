import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<AppSettings> getSettings() async {
    return await _dataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _dataSource.saveSettings(settings);
  }
}
