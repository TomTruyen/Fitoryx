import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectionService {
  // Singleton Setup
  static final ConnectionService _connectionService =
      ConnectionService._internal();

  factory ConnectionService() {
    return _connectionService;
  }

  ConnectionService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool offline = false;

  Future<void> init(bool mounted, GlobalKey<ScaffoldMessengerState> key) async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) => _updateConnectionState(result, key),
    );

    return _updateConnectionState(result, key);
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  void _updateConnectionState(
      ConnectivityResult result, GlobalKey<ScaffoldMessengerState> key) async {
    key.currentState?.hideCurrentSnackBar();
    switch (result) {
      case ConnectivityResult.ethernet:
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _showOnline(key);
        break;
      default:
        _showOffline(key);
        break;
    }
  }

  _showOnline(GlobalKey<ScaffoldMessengerState> key) {
    if (offline) {
      offline = false;

      var snackBar = const SnackBar(
        duration: Duration(seconds: 5),
        content: Text("You have been reconnected!"),
      );

      key.currentState?.showSnackBar(snackBar);
    }
  }

  _showOffline(GlobalKey<ScaffoldMessengerState> key) {
    if (!offline) {
      offline = true;

      var snackBar = const SnackBar(
        duration: Duration(days: 1),
        dismissDirection: DismissDirection.none,
        content: Text("You are offline! Please reconnect to the internet."),
      );

      key.currentState?.showSnackBar(snackBar);
    }
  }
}
