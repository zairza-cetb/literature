// Port
const port = 34263;

// Global imports
var websocketServer = require('websocket').server;
var http = require('http');

// Create an HTTP server that would implement
// websockets after a handshake with the client
var server = http.createServer(function() {
  // TODO
});
server.listen(port, function() {
  console.log('Connected on PORT: ' + port);
});

// Websocket server
// @override HTTP server
var wsServer = new websocketServer({
  httpServer: server
});
wsServer.on('request', function(request) {
  var connection = request.accept(null, request.origin);
  // Record the socket of a new player
  var player = new Player(request.key, connection);

  // Add to players list
  Players.push(player);

  // Return an unique ID of the player itself
  connection.sendUTF(JSON.stringify({action: 'connect', data: player.id}));

  // Listen to any message sent by any player
  connection.on('message', function(data) {
    // Process the requested action
    var message = JSON.parse(data.utf8Data);
    // Route to specific handlers based on
    // the message action
    switch (message.action) {
      // When the user sends the "join" action, he provides a name.
      // Let's record it and as the player has a name, let's 
      // broadcast the list of all the players to everyone.
      case 'join':
        player.name = message.data;
        BroadcastPlayersList();
        // player.name = message.data;
        // player
        //   .connection
        //   .sendUTF(JSON.stringify({'action':'join_server', 'name': player.name, 'role': null}));
        break;
      //
      // When a player resigns, we need to break the relationship
      // between the players and notify the other player 
      // that the first one resigned
      //
      case 'resign':
        // TODO: Implement this for all players
        Players[player.opponentIndex]
          .connection
          .sendUTF(JSON.stringify({'action':'resigned'}));
        // Async calls that won't break going to the next step
        // because of say: network lags
        setTimeout(function(){
          Players[player.opponentIndex].opponentIndex = player.opponentIndex = null;
        }, 0);
        break;
      /**
       * A player creates a new game
       */
      case 'create_game':
        // Set the person who created the game,
        // Update opponent when a move is made
        // by a player.
        player.name = message.data;
        player.setCreator(player.name);
        BroadcastPlayersList();
        // A person creates a new game
        // TODO: Send the player as per a room
        player
          .connection
          .sendUTF(JSON.stringify({'action':'create_game', 'name': player.name }));
        break;
      

      /**
       *  A player initiates a new game. We need to 
       *  notify all players that a new game has started.
       */ 
      case 'new_game':
        // Set the person who created the game,
        // Update opponent when a move is made
        // by a player.
        player.setOpponent(message.data);
        // TODO: Send to all players.
        Players[player.opponentIndex]
              .connection
              .sendUTF(JSON.stringify({'action':'new_game', 'data': player.name, 'role': player.gameCreator}));
        break;

      /**
       * A player sends a move.  Let's forward the move to the other players.
       */
      case 'play':
        Players[player.opponentIndex]
          .connection
          .sendUTF(JSON.stringify({'action':'play', 'data': message.data}));
        break;
    };
  });

  // user disconnected
  connection.on('close', function(connection) {
    // We need to remove the corresponding player
    // TODO
  });
});


// Models and other stuff
var Players = [];
function Player(id, connection) {
  this.id = id;
  this.connection = connection;
  this.name = "";
  this.opponentIndex = null;
  this.index = Players.length;
  this.gameCreator = null;
}

Player.prototype = {
  getId: function() {
    return { name: this.name, id: this.id, gameCreator: this.gameCreator };
  },
  setOpponent: function(id) {
    var self = this;
    Players.forEach(function(player,  index) {
      if (player.id === id) {
        self.opponentIndex = index;
        Players[index].opponentIndex = self.index;
        return false;
      }
    });
  },
  setCreator: function(id) {
    var self = this;
    Players.forEach(function(player,  index) {
      if (player.name === id) {
        self.gameCreator = index;
        return false;
      }
    });
  }
};

// ---------------------------------------------------------
// Routine to broadcast the list of all players to everyone
// ---------------------------------------------------------
function BroadcastPlayersList(){
  var playersList = [];
  Players.forEach(function(player){
      if (player.name !== ''){
          playersList.push(player.getId());
      }
  });

  var message = JSON.stringify({
      'action': 'players_list',
      'data': playersList
  });
  console.log(playersList);

  Players.forEach(function(player){
      player.connection.sendUTF(message);
  });
};
