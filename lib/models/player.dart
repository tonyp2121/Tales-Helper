import 'package:flutter/material.dart';
import '../data/game_constants.dart';

class Player {
  String name;
  Color color;
  String colorName;
  int destinyPoints;
  int storyPoints;
  int wealth; // 0-6 index into wealthLevels
  List<bool> statuses; // 28 statuses
  List<bool> tokens; // 18 tokens

  Player({
    required this.name,
    required this.color,
    required this.colorName,
    this.destinyPoints = 0,
    this.storyPoints = 0,
    this.wealth = 0,
  })  : statuses = List.filled(28, false),
        tokens = List.filled(18, false);

  String get wealthName => GameConstants.wealthLevels[wealth];

  int get landTradeValue {
    int base = GameConstants.defaultLandTrade[wealth];
    // Status 4 (Crippled) and 6 (Diseased) reduce land wealth by 1
    if (statuses[4]) base -= 1;
    if (statuses[6]) base -= 1;
    // Status 14 (Lost) sets both to 1
    if (statuses[14]) base = 1;
    if (base < 1) base = 1;
    return base;
  }

  int get seaTradeValue {
    int base = GameConstants.defaultSeaTrade[wealth];
    // Status 4 (Crippled) and 6 (Diseased) reduce sea wealth by 1
    if (statuses[4]) base -= 1;
    if (statuses[6]) base -= 1;
    // Status 14 (Lost) sets both to 1
    if (statuses[14]) base = 1;
    // Token 11 (Seafaring) ensures minimum sea value of 4
    if (tokens[9] && base < 4) base = 4;
    if (base < 1) base = 1;
    return base;
  }

  List<int> get activeStatusIndices {
    final result = <int>[];
    for (int i = 0; i < statuses.length; i++) {
      if (statuses[i]) result.add(i);
    }
    return result;
  }

  List<int> get activeTokenIndices {
    final result = <int>[];
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i]) result.add(i);
    }
    return result;
  }
}
