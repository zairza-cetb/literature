import 'package:flutter/widgets.dart';
import 'package:literature/utils/enums.dart';

PlayerConnectivity playerConnectivity = new PlayerConnectivity();

class PlayerConnectivity extends ChangeNotifier {
  static final PlayerConnectivity playerConnectivity =
      new PlayerConnectivity._internal();

  factory PlayerConnectivity() => playerConnectivity;

  PlayerConnectivityStatus status;

  PlayerConnectivity._internal();

  changeStatus(PlayerConnectivityStatus newStatus) {
    status = newStatus;
    notifyListeners();
  }

  checkStatus() => status;
}
