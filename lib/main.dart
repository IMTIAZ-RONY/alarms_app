import 'package:alarms_app/src/presentation/providers/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/data/repositories/reminder_repository_impl.dart';
import 'src/domain/usecases/get_reminders_usecase.dart';
import 'src/domain/usecases/set_reminder_usecase.dart';
//import 'src/presentation/providers/reminder_provider.dart';
import 'src/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();

  final repository = ReminderRepositoryImpl();
  final getRemindersUseCase = GetRemindersUseCase(repository);
  final setReminderUseCase = SetReminderUseCase(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ReminderProvider(
        getRemindersUseCase: getRemindersUseCase,
        setReminderUseCase: setReminderUseCase,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}