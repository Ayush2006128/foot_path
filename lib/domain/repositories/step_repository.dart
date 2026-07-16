import '../entities/daily_steps.dart';

abstract class StepRepository {
  Future<DailySteps> getStepsForDate(DateTime date);
  Future<List<DailySteps>> getWeeklySteps(DateTime endDate);
  Future<void> saveSteps(DailySteps dailySteps);
  
  /// Stream of steps from the pedometer sensor, relative to the app start or day start.
  Stream<int> get stepStream;
}
