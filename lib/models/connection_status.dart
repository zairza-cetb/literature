import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:literature/utils/game_communication.dart';

class ConnectionStatus extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool hasConnection;
  bool previousConnection;
  bool shouldShowSnackbar = false;

  ConnectionStatus() {
    _initializeConnection();

    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection(result);
  }

  checkConnection(ConnectivityResult status) async {
    previousConnection = hasConnection;
    if (status == ConnectivityResult.mobile ||
        status == ConnectivityResult.wifi) {

      try {
        final lookup = await InternetAddress.lookup('google.com');
        if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
          hasConnection = true;
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    } else {
      hasConnection = false;
    }

    if (previousConnection != hasConnection || previousConnection == false) {
      shouldShowSnackbar = true;
      notifyListeners();
    }
  }

  void snackbarComplete() {
    shouldShowSnackbar = false;
  }

  void _initializeConnection() async {
    var currentConnectivity = await _connectivity.checkConnectivity();
    hasConnection =
        (currentConnectivity == ConnectivityResult.none) ? false : true;
  }
}
