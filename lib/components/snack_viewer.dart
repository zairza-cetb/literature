import 'package:flutter/material.dart';
import 'package:literature/models/connection_status.dart';
import 'package:provider/provider.dart';

class Snacky extends StatelessWidget {
  bool connectionStatus;
  bool previousConnectionStatus;
  var title;

  Snacky({Key key, this.connectionStatus}) : super(key: key);

  String _networkConnection(bool connectionStatus) {
    if (connectionStatus == true) {
      return 'Connected!!';
    } else {
      return 'No Internet Connection!!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionStatus>(builder: (context, status, child) {
      if (status.shouldShowSnackbar) {
        connectionStatus = status.hasConnection;
        previousConnectionStatus = status.previousConnection;
        status.snackbarComplete();
        title = _networkConnection(connectionStatus);
        WidgetsBinding.instance
            .addPostFrameCallback((_) => onAfterBuild(context));
      }
      return SizedBox.shrink();
    });
  }

  onAfterBuild(BuildContext context) {
    if (previousConnectionStatus != connectionStatus ||
        previousConnectionStatus == false) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(title),
          backgroundColor: colorProvider(title),
          // duration: Duration(),
        ));
    }
  }

  Color colorProvider(String status) {
    if (status == 'Connected!!') {
      return Color.fromRGBO(0, 255, 0, 1);
    } else {
      return Color.fromRGBO(255, 0, 0, 1);
    }
  }
}
