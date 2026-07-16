import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import '../models/daily_steps_model.dart';

class LocalStepDataSource {
  static const String boxName = 'daily_steps_box';
  
  final Box<DailyStepsModel> _box;

  LocalStepDataSource(this._box);

  static Future<Box<DailyStepsModel>> openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<DailyStepsModel>(boxName);
    }
    return Hive.box<DailyStepsModel>(boxName);
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<DailyStepsModel?> getStepsForDate(DateTime date) async {
    final key = _formatDate(date);
    return _box.get(key);
  }

  Future<List<DailyStepsModel>> getWeeklySteps(DateTime endDate) async {
    final List<DailyStepsModel> weeklySteps = [];
    for (int i = 6; i >= 0; i--) {
      final date = endDate.subtract(Duration(days: i));
      final model = await getStepsForDate(date);
      if (model != null) {
        weeklySteps.add(model);
      } else {
        // Add empty entry for days with no data
        weeklySteps.add(DailyStepsModel(date: date, steps: 0));
      }
    }
    return weeklySteps;
  }

  Future<void> saveSteps(DailyStepsModel steps) async {
    final key = _formatDate(steps.date);
    await _box.put(key, steps);
  }
}
