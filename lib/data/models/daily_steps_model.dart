import 'package:hive_ce/hive.dart';
import '../../domain/entities/daily_steps.dart';

part 'daily_steps_model.g.dart';

@HiveType(typeId: 0)
class DailyStepsModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int steps;

  DailyStepsModel({
    required this.date,
    required this.steps,
  });

  factory DailyStepsModel.fromEntity(DailySteps entity) {
    return DailyStepsModel(
      date: entity.date,
      steps: entity.steps,
    );
  }

  DailySteps toEntity() {
    return DailySteps(
      date: date,
      steps: steps,
    );
  }
}
