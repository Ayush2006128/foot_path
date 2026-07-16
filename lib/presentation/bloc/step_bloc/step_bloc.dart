import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../../domain/entities/daily_steps.dart';
import '../../../domain/repositories/step_repository.dart';
import '../../../data/datasources/tracking_service.dart';
import 'step_event.dart';
import 'step_state.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final StepRepository repository;
  StreamSubscription<int>? _stepSubscription;

  StepBloc({required this.repository}) : super(StepInitial()) {
    on<LoadSteps>(_onLoadSteps);
    on<UpdateSteps>(_onUpdateSteps);
    on<ToggleTracking>(_onToggleTracking);
    
    // Listen to ReceivePort from foreground task
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
  }

  void _onReceiveTaskData(dynamic data) {
    if (data is int) {
      add(UpdateSteps(data));
    }
  }

  Future<void> _onLoadSteps(LoadSteps event, Emitter<StepState> emit) async {
    emit(StepLoading());
    try {
      final today = DateTime.now();
      final dailySteps = await repository.getStepsForDate(today);
      final weeklySteps = await repository.getWeeklySteps(today);
      final isTracking = await FlutterForegroundTask.isRunningService;

      emit(StepLoaded(
        currentSteps: dailySteps.steps,
        weeklySteps: weeklySteps,
        isTracking: isTracking,
      ));

      if (isTracking) {
        _subscribeToSteps();
      }
    } catch (e) {
      emit(StepError(e.toString()));
    }
  }

  Future<void> _onUpdateSteps(UpdateSteps event, Emitter<StepState> emit) async {
    if (state is StepLoaded) {
      final currentState = state as StepLoaded;
      
      // Save to repo
      await repository.saveSteps(DailySteps(date: DateTime.now(), steps: event.steps));
      
      // Update weekly steps (just replace today's entry)
      final today = DateTime.now();
      final updatedWeekly = currentState.weeklySteps.map((ds) {
        if (ds.date.year == today.year && ds.date.month == today.month && ds.date.day == today.day) {
          return DailySteps(date: today, steps: event.steps);
        }
        return ds;
      }).toList();

      emit(currentState.copyWith(
        currentSteps: event.steps,
        weeklySteps: updatedWeekly,
      ));
    }
  }

  Future<void> _onToggleTracking(ToggleTracking event, Emitter<StepState> emit) async {
    if (state is StepLoaded) {
      final currentState = state as StepLoaded;
      final isCurrentlyTracking = currentState.isTracking;

      try {
        if (isCurrentlyTracking) {
          await TrackingService.stopTracking();
          _stepSubscription?.cancel();
          emit(currentState.copyWith(isTracking: false));
        } else {
          final started = await TrackingService.startTracking();
          if (started) {
            _subscribeToSteps();
            emit(currentState.copyWith(isTracking: true));
          }
        }
      } catch (e) {
        emit(StepError("Failed to toggle tracking: $e"));
      }
    }
  }

  void _subscribeToSteps() {
    _stepSubscription?.cancel();
    _stepSubscription = repository.stepStream.listen((steps) {
      add(UpdateSteps(steps));
    });
  }

  @override
  Future<void> close() {
    _stepSubscription?.cancel();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    return super.close();
  }
}
