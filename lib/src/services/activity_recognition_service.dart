import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/di/di.dart';
import '../data/remote/firestore_client.dart';
import '../global/global.dart';
import '../presentation/home/cubit/steps_cubit.dart';
import '../presentation/map/cubit/my_marker_cubit.dart';

class ActivityRecognitionService {
  ActivityRecognitionService._privateConstructor();

  static final ActivityRecognitionService instance =
      ActivityRecognitionService._privateConstructor();
  final FirestoreClient _firestoreClient = FirestoreClient.instance;
  String? oldActivity = Global.instance.user?.activityType;
  final activityRecognition = FlutterActivityRecognition.instance;

  Future<void> initActivityRecognitionService() async {
    if (await isPermissionGrants()) {
      initStreamActivityRecognition();
      initStepsStream();
    }
  }

  Future<bool> isPermissionGrants() async {
    PermissionStatus activityRecognition;
    if (Platform.isIOS) {
      activityRecognition = await Permission.sensors.status;
    } else {
      activityRecognition = await Permission.activityRecognition.status;
    }
    return activityRecognition.isGranted;
  }

  Future<void> initStreamActivityRecognition() async {
    String activityTemp = 'STILL';

    activityRecognition.activityStream.handleError((error) {}).listen(
      (Activity activity) {
        activityTemp = activity.type.name;
      },
    );
    Timer.periodic(const Duration(minutes: 2), (timer) {
      if (oldActivity != activityTemp && activityTemp != 'UNKNOWN') {
        oldActivity = activityTemp;
        Global.instance.user = Global.instance.user
            ?.copyWith(activityType: oldActivity ?? 'STILL');
        getIt<MyMarkerCubit>().update(Global.instance.user);
        _firestoreClient.updateUser({'activityType': oldActivity});
      }
    });
  }

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  Future<void> initStepsStream() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint('$event');
    print('event: $event');
  }

  //đếm bước chân
  Future<void> onStepCount(StepCount event) async {
    debugPrint('step count: $event');
    print('event: $event');
    getIt<StepsCubit>().update(event.steps);

    Future.delayed(const Duration(minutes: 5), () async {
      int battery = 100;
      try {
        battery = await Battery().batteryLevel;
      } catch (e) {}
      _firestoreClient.updateUser({
        'steps': getIt<StepsCubit>().state,
        'batteryLevel': battery,
      });
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
  }
}
