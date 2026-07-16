import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_step_datasource.dart';
import 'data/datasources/settings_datasource.dart';
import 'data/datasources/tracking_service.dart';
import 'data/models/daily_steps_model.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/step_repository_impl.dart';
import 'domain/entities/app_settings.dart';
import 'presentation/bloc/settings_bloc/settings_bloc.dart';
import 'presentation/bloc/settings_bloc/settings_event.dart';
import 'presentation/bloc/settings_bloc/settings_state.dart';
import 'presentation/bloc/step_bloc/step_bloc.dart';
import 'presentation/bloc/step_bloc/step_event.dart';
import 'presentation/pages/main_layout_page.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request permissions
  await [
    Permission.activityRecognition,
    Permission.notification,
  ].request();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(DailyStepsModelAdapter());
  final stepsBox = await LocalStepDataSource.openBox();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Setup Dependency Injection
  sl.registerLazySingleton(() => LocalStepDataSource(stepsBox));
  sl.registerLazySingleton(() => SettingsDataSource(prefs));
  sl.registerLazySingleton(() => StepRepositoryImpl(sl<LocalStepDataSource>()));
  sl.registerLazySingleton(() => SettingsRepositoryImpl(sl<SettingsDataSource>()));

  // Initialize Foreground Task
  TrackingService.initForegroundTask();

  runApp(const FootPathApp());
}

class FootPathApp extends StatelessWidget {
  const FootPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsBloc(repository: sl<SettingsRepositoryImpl>())..add(LoadSettings()),
        ),
        BlocProvider(
          create: (_) => StepBloc(repository: sl<StepRepositoryImpl>())..add(LoadSteps()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;
          if (state is SettingsLoaded) {
            switch (state.settings.themeMode) {
              case ThemeModeOption.light:
                themeMode = ThemeMode.light;
                break;
              case ThemeModeOption.dark:
                themeMode = ThemeMode.dark;
                break;
              case ThemeModeOption.system:
                themeMode = ThemeMode.system;
                break;
            }
          }

          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp(
                title: 'Foot Path',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.getLightTheme(colorScheme: lightDynamic),
                darkTheme: AppTheme.getDarkTheme(colorScheme: darkDynamic),
                themeMode: themeMode,
                home: const MainLayoutPage(),
              );
            },
          );
        },
      ),
    );
  }
}
