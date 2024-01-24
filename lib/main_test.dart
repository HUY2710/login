import 'dart:async';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const ActivityRecognitionApp());

class ActivityRecognitionApp extends StatefulWidget {
  const ActivityRecognitionApp({super.key});

  @override
  _ActivityRecognitionAppState createState() => _ActivityRecognitionAppState();
}

class _ActivityRecognitionAppState extends State<ActivityRecognitionApp> {
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  final List<ActivityEvent> _events = [];
  ActivityRecognition activityRecognition = ActivityRecognition();

  @override
  void initState() {
    super.initState();
    _init();
    _events.add(ActivityEvent.unknown());
  }

  @override
  void dispose() {
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      // Android requires explicitly asking permission
      if (Platform.isAndroid) {
        if (await Permission.activityRecognition.request().isGranted) {
          _startTracking();
        }
      }

      // iOS does not
      else {
        _startTracking();
      }
    } catch (e) {
      debugPrint('error:$e');
    }
  }

  void _startTracking() {
    try {
      activityStreamSubscription =
          activityRecognition.activityStream().listen(onData, onError: onError);
    } catch (e) {
      debugPrint('e:$e');
    }
  }

  void onData(ActivityEvent activityEvent) {
    print(activityEvent);
    try {
      setState(() {
        _events.add(activityEvent);
      });
    } catch (e) {
      debugPrint('error:$e');
    }
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Recognition'),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: _events.length,
              reverse: true,
              itemBuilder: (_, int idx) {
                final activity = _events[idx];
                return ListTile(
                  leading: _activityIcon(activity.type),
                  title: Text(
                      '${activity.type.toString().split('.').last} (${activity.confidence}%)'),
                  trailing: Text(activity.timeStamp
                      .toString()
                      .split(' ')
                      .last
                      .split('.')
                      .first),
                );
              }),
        ),
      ),
    );
  }

  Icon _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.WALKING:
        return const Icon(Icons.directions_walk);
      case ActivityType.IN_VEHICLE:
        return const Icon(Icons.car_rental);
      case ActivityType.ON_BICYCLE:
        return const Icon(Icons.pedal_bike);
      case ActivityType.ON_FOOT:
        return const Icon(Icons.directions_walk);
      case ActivityType.RUNNING:
        return const Icon(Icons.run_circle);
      case ActivityType.STILL:
        return const Icon(Icons.cancel_outlined);
      case ActivityType.TILTING:
        return const Icon(Icons.redo);
      default:
        return const Icon(Icons.device_unknown);
    }
  }
}
