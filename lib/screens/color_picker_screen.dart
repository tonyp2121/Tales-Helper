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
      curve: Curves.easeOut,
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
      final gameState = Provider.of<GameState>(context, listen: false);
      gameState.setupPlayers(_players);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF152238),
              Color(0xFF1B2D4A),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.playerCount, (i) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= _currentPlayerSetup
                              ? const Color(0xFFD4A574)
                              : const Color(0xFFD4A574).withValues(alpha: 0.2),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Player ${_currentPlayerSetup + 1}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose your character',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white38,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 24,
                    runSpacing: 28,
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
                            opacity: isUsed ? 0.25 : 1.0,
                            child: Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorInfo.color == Colors.white
                                        ? Colors.white
                                        : colorInfo.color == Colors.black
                                            ? const Color(0xFF2A2A2A)
                                            : colorInfo.color,
                                    border: Border.all(
                                      color: colorInfo.color == Colors.black
                                          ? Colors.white24
                                          : colorInfo.color == Colors.white
                                              ? Colors.white60
                                              : colorInfo.color
                                                  .withValues(alpha: 0.6),
                                      width: 2,
                                    ),
                                    boxShadow: isUsed
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: (colorInfo.color ==
                                                          Colors.black
                                                      ? Colors.blueGrey
                                                      : colorInfo.color)
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 16,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                  ),
                                  child: isUsed
                                      ? const Icon(Icons.check,
                                          color: Colors.white38, size: 28)
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  colorInfo.characterName,
                                  style: TextStyle(
                                    color: isUsed
                                        ? Colors.white24
                                        : const Color(0xFFD4A574),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  colorInfo.colorName,
                                  style: TextStyle(
                                    color:
                                        isUsed ? Colors.white12 : Colors.white30,
                                    fontSize: 11,
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
      ),
    );
  }
}
