import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:literature/models/player.dart';

class PlayerList extends ChangeNotifier {

  final List<Player> _list=[];
  final List<Player> _currPlayer=[];

  UnmodifiableListView<Player> get players => UnmodifiableListView(_list);
  double currency = 0.00;
  Player get currPlayer => _currPlayer.first;

  void addCurrency(double c) {
    currency += c;
    currency = double.parse(currency.toStringAsFixed(2));
  }

  void deductCurrency (double c) {
    currency -= c;
  }

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