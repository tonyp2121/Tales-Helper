import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/game_constants.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import 'game_screen.dart';

class ColorPickerScreen extends StatefulWidget {
  final int playerCount;

  const ColorPickerScreen({super.key, required this.playerCount});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen>
    with SingleTickerProviderStateMixin {
  int _currentPlayerSetup = 0;
  final List<Player> _players = [];
  final Set<int> _usedColorIndices = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _selectColor(int colorIndex) {
    final colorInfo = GameConstants.playerColors[colorIndex];
    _players.add(Player(
      name: colorInfo.characterName,
      color: colorInfo.color,
      colorName: colorInfo.colorName,
    ));
    _usedColorIndices.add(colorIndex);

    if (_currentPlayerSetup + 1 >= widget.playerCount) {
      // All players set up
      final gameState = Provider.of<GameState>(context, listen: false);
      gameState.setupPlayers(_players);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentPlayerSetup++;
        });
        _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Player ${_currentPlayerSetup + 1}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFD4A574),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your color',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    GameConstants.playerColors.length,
                    (index) {
                      final colorInfo = GameConstants.playerColors[index];
                      final isUsed = _usedColorIndices.contains(index);
                      return GestureDetector(
                        onTap: isUsed ? null : () => _selectColor(index),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isUsed ? 0.3 : 1.0,
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: colorInfo.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorInfo.color == Colors.black
                                        ? Colors.white54
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: isUsed
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: colorInfo.color
                                                .withValues(alpha: 0.4),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                ),
                                child: isUsed
                                    ? const Icon(Icons.check,
                                        color: Colors.white54, size: 36)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                colorInfo.colorName,
                                style: TextStyle(
                                  color: isUsed ? Colors.white30 : Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                colorInfo.characterName,
                                style: TextStyle(
                                  color: isUsed
                                      ? Colors.white24
                                      : const Color(0xFFD4A574),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
