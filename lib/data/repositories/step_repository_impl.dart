import 'package:pedometer/pedometer.dart';
import '../../domain/entities/daily_steps.dart';
import '../../domain/repositories/step_repository.dart';
import '../datasources/local_step_datasource.dart';
import '../models/daily_steps_model.dart';

class StepRepositoryImpl implements StepRepository {
  final LocalStepDataSource _localDataSource;

  StepRepositoryImpl(this._localDataSource);

  @override
  Future<DailySteps> getStepsForDate(DateTime date) async {
    final model = await _localDataSource.getStepsForDate(date);
    return model?.toEntity() ?? DailySteps(date: date, steps: 0);
  }

  @override
  Future<List<DailySteps>> getWeeklySteps(DateTime endDate) async {
    final models = await _localDataSource.getWeeklySteps(endDate);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSteps(DailySteps dailySteps) async {
    final model = DailyStepsModel.fromEntity(dailySteps);
    await _localDataSource.saveSteps(model);
  }
  
  @override
  Stream<int> get stepStream => Pedometer.stepCountStream.map((event) => event.steps);
}
