import 'package:equatable/equatable.dart';

class DailySteps extends Equatable {
  final DateTime date;
  final int steps;

  const DailySteps({
    required this.date,
    required this.steps,
  });

  @override
  List<Object?> get props => [date, steps];
}
