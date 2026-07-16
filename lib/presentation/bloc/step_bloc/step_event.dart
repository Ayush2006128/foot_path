import 'package:equatable/equatable.dart';

abstract class StepEvent extends Equatable {
  const StepEvent();

  @override
  List<Object> get props => [];
}

class LoadSteps extends StepEvent {}

class UpdateSteps extends StepEvent {
  final int steps;

  const UpdateSteps(this.steps);

  @override
  List<Object> get props => [steps];
}

class ToggleTracking extends StepEvent {}
