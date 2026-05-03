import 'package:flutter/material.dart';
import 'player.dart';

class GameState extends ChangeNotifier {
  List<Player> _players = [];
  int _currentPlayerIndex = 0;

  List<Player> get players => _players;
  int get currentPlayerIndex => _currentPlayerIndex;
  Player get currentPlayer => _players[_currentPlayerIndex];
  int get playerCount => _players.length;

  void setupPlayers(List<Player> players) {
    _players = players;
    _currentPlayerIndex = 0;
    notifyListeners();
  }

  void nextPlayer() {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
    notifyListeners();
  }

  void updateDestiny(int delta) {
    final newVal = currentPlayer.destinyPoints + delta;
    if (newVal >= 0 && newVal <= 20) {
      currentPlayer.destinyPoints = newVal;
      notifyListeners();
    }
  }

  void updateStory(int delta) {
    final newVal = currentPlayer.storyPoints + delta;
    if (newVal >= 0 && newVal <= 20) {
      currentPlayer.storyPoints = newVal;
      notifyListeners();
    }
  }

  void updateWealth(int delta) {
    final newVal = currentPlayer.wealth + delta;
    if (newVal >= 0 && newVal <= 6) {
      currentPlayer.wealth = newVal;
      notifyListeners();
    }
  }

  void toggleStatus(int index) {
    currentPlayer.statuses[index] = !currentPlayer.statuses[index];
    notifyListeners();
  }

  void toggleToken(int index) {
    currentPlayer.tokens[index] = !currentPlayer.tokens[index];
    notifyListeners();
  }

  void setStatus(int index, bool value) {
    currentPlayer.statuses[index] = value;
    notifyListeners();
  }

  void setToken(int index, bool value) {
    currentPlayer.tokens[index] = value;
    notifyListeners();
  }
}
