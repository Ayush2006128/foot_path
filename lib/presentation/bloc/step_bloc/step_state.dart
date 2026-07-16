import 'package:equatable/equatable.dart';
import '../../../domain/entities/daily_steps.dart';

abstract class StepState extends Equatable {
  const StepState();

  @override
  List<Object> get props => [];
}

class StepInitial extends StepState {}

class StepLoading extends StepState {}

class StepLoaded extends StepState {
  final int currentSteps;
  final List<DailySteps> weeklySteps;
  final bool isTracking;

  const StepLoaded({
    required this.currentSteps,
    required this.weeklySteps,
    required this.isTracking,
  });

  StepLoaded copyWith({
    int? currentSteps,
    List<DailySteps>? weeklySteps,
    bool? isTracking,
  }) {
    return StepLoaded(
      currentSteps: currentSteps ?? this.currentSteps,
      weeklySteps: weeklySteps ?? this.weeklySteps,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  @override
  List<Object> get props => [currentSteps, weeklySteps, isTracking];
}

class StepError extends StepState {
  final String message;

  const StepError(this.message);

  @override
  List<Object> get props => [message];
}
