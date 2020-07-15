import 'package:literature/utils/websocket.dart';

///
/// Global variable, the whole class is 
/// accessible through this variable.
///
GameCommunication game = new GameCommunication();

class GameCommunication {
  connect() {
    socket.initCommunication();
  }

  disconnect() {
    socket.reset();
  }  

  /// ----------------------------------------------------------
  /// Common method to send requests to the server
  /// ----------------------------------------------------------
  send(String action, String data){
    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON 
    ///
    socket.send(action, data);
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback){
    socket.addListener(callback);
  }
  removeListener(Function callback){
    socket.removeListener(callback);
  }
}
