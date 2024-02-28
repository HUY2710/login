import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../config/di/di.dart';
import '../config/navigation/app_router.dart';
import '../shared/widgets/dialog/no_internet_dialog.dart';

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();

  final _controller = BehaviorSubject<Map<ConnectivityResult, bool>>();
  Stream<Map<ConnectivityResult, bool>> get myStream => _controller.stream;
  bool isShowDialog = false;
  Future<bool> initial() async {
    final ConnectivityResult result =
        await _networkConnectivity.checkConnectivity();
    final bool status = await _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) async {
      await _checkStatus(result);
      if (isShowDialog && result != ConnectivityResult.none) {
        getIt<AppRouter>().navigatorKey.currentContext!.popRoute();
        isShowDialog = false;
      }
    });
    return status;
  }

  Future<bool> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    final Map<ConnectivityResult, bool> data = {result: isOnline};
    _controller.sink.add(data);
    if (result == ConnectivityResult.none && isShowDialog == false) {
      isShowDialog = true;
      showDialog(
          barrierDismissible: false,
          context: getIt<AppRouter>().navigatorKey.currentContext!,
          builder: (context) => const NoIternetDialog());
    }

    return isOnline;
  }

  void disposeStream() => _controller.close();
}
