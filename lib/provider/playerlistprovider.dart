import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:literature/models/player.dart';

class PlayerList extends ChangeNotifier {

  final List<Player> _list=[];
  final List<Player> _currPlayer=[];

  UnmodifiableListView<Player> get players => UnmodifiableListView(_list);
  Player get currPlayer => _currPlayer.first;

  void addPlayer(Player p){
    _list.add(p);
    notifyListeners();
  }

  void addCurrPlayer(Player p){
    _currPlayer.clear();
    _currPlayer.add(p);
    notifyListeners();
  }

  void addPlayers(List<Player> p) {
    removeAll();
    _list.addAll(p);
    notifyListeners();
  }

  void removeAll(){
    _list.clear();
  }

  Player getLeader(){
    return _list.firstWhere((player) => player.lobbyLeader);
  }
}