import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(StepTaskHandler());
}

class StepTaskHandler extends TaskHandler {
  int _steps = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    Pedometer.stepCountStream.listen((StepCount event) {
      _steps = event.steps;
      FlutterForegroundTask.updateService(
        notificationTitle: 'Foot Path is Tracking',
        notificationText: 'Steps today: $_steps',
      );
      FlutterForegroundTask.sendDataToMain(_steps);
    }).onError((error) {
      if (kDebugMode) {
        print("Pedometer error: $error");
      }
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // We update on stream events, so we might not need this.
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    // Cleanup if needed
  }
}

class TrackingService {
  static void initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foot_path_foreground_service',
        channelName: 'Step Tracking Service',
        channelDescription: 'Keeps the app alive to track steps',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<bool> startTracking() async {
    if (await FlutterForegroundTask.isRunningService) {
      final result = await FlutterForegroundTask.restartService();
      return result is ServiceRequestSuccess;
    } else {
      final result = await FlutterForegroundTask.startService(
        notificationTitle: 'Foot Path is Tracking',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
      return result is ServiceRequestSuccess;
    }
  }

  static Future<bool> stopTracking() async {
    final result = await FlutterForegroundTask.stopService();
    return result is ServiceRequestSuccess;
  }
}
