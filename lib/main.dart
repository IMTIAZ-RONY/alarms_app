import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alarm_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alarm Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AlarmSettings> alarms = [];

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    //notifcation permission
    checkAndroidNotificationPermission();
    //schedule alarm permission
    checkAndroidScheduleExactAlarmPermission();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    //listen alarm if active than navigate to alarm screen
  }

Future<void> loadAlarms() async {
    setState(() async {
      alarms = await Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      print('Requesting notification permission...');
      final res = await Permission.notification.request();
      print(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) {
      print('Schedule exact alarm permission: $status.');
    }
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting schedule exact alarm permission...');
      }
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: List.generate(
            alarms.length,
                (index) => ListTile(
              title: Text(alarms[index].dateTime.toString()),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var alarmDateTime = DateTime.now().add(const Duration(seconds: 30));
          final alarmSettings = AlarmSettings(
            id: 42,
            dateTime: alarmDateTime,
            assetAudioPath: 'assets/alarm_rooster.mp3',
            loopAudio: true,
            vibrate: true,
            warningNotificationOnKill: Platform.isIOS,
            androidFullScreenIntent: true,
            volumeSettings: VolumeSettings.fade(
              volume: 0.8,
              fadeDuration: Duration(seconds: 3),
              volumeEnforced: true,
            ),
            notificationSettings: NotificationSettings(
              title: 'This is the title',
              body: 'This is the body',
              stopButton: 'Stop',
            ),
          );

          await Alarm.set(alarmSettings: alarmSettings);
          loadAlarms();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}