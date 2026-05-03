import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/game_constants.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/player_stats.dart';
import '../widgets/token_picker.dart';
import '../widgets/status_picker.dart';
import 'encounter_screen.dart';
import 'setup_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _transitionAnimation;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _transitionAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _nextPlayer() {
    if (_isTransitioning) return;
    _isTransitioning = true;

    _transitionController.forward().then((_) {
      Provider.of<GameState>(context, listen: false).nextPlayer();
      _transitionController.reverse().then((_) {
        _isTransitioning = false;
      });
    });
  }

  void _openEncounter() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EncounterScreen()),
    );
  }

  void _showTokenPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const TokenPicker(),
    );
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const StatusPicker(),
    );
  }

  void _showStatusDetails(int statusIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          GameConstants.statusNames[statusIndex],
          style: const TextStyle(color: Color(0xFFD4A574)),
        ),
        content: SingleChildScrollView(
          child: Text(
            GameConstants.statusDescriptions[statusIndex],
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<GameState>(context, listen: false)
                  .toggleStatus(statusIndex);
              Navigator.pop(context);
            },
            child: const Text('Remove Status',
                style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFFD4A574))),
          ),
        ],
      ),
    );
  }

  void _confirmNewGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('New Game?',
            style: TextStyle(color: Color(0xFFD4A574))),
        content: const Text('Start a new game? All progress will be lost.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SetupScreen()),
                (route) => false,
              );
            },
            child: const Text('New Game',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
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
              Color(0xFF122035),
              Color(0xFF0D1B2A),
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom app bar
            SafeArea(
              bottom: false,
              child: Consumer<GameState>(
                builder: (context, state, _) {
                  final player = state.currentPlayer;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: player.color == Colors.black
                                ? const Color(0xFF2A2A2A)
                                : player.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: player.color == Colors.black
                                  ? Colors.white24
                                  : player.color.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (player.color == Colors.black
                                        ? Colors.blueGrey
                                        : player.color)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          player.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.currentPlayerIndex + 1} / ${state.playerCount}',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _confirmNewGame,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.refresh_rounded,
                                color: Colors.white24, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Main content
            Expanded(
              child: AnimatedBuilder(
                animation: _transitionAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1.0 - _transitionAnimation.value,
                    child: child,
                  );
                },
                child: Consumer<GameState>(
                  builder: (context, state, _) {
                    final player = state.currentPlayer;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 700) {
                          return _buildWideLayout(state, player);
                        }
                        return _buildNarrowLayout(state, player);
                      },
                    );
                  },
                ),
              ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.search_rounded,
                        label: 'Encounter',
                        onTap: _openEncounter,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBottomButton(
                        icon: Icons.arrow_forward_rounded,
                        label: 'Next Player',
                        onTap: _nextPlayer,
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFFD4A574)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: isPrimary
                    ? const Color(0xFF0D1B2A)
                    : Colors.white60),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? const Color(0xFF0D1B2A)
                    : Colors.white60,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(GameState state, Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: PlayerStats(
              player: player,
              onDestinyChanged: (d) => state.updateDestiny(d),
              onStoryChanged: (d) => state.updateStory(d),
              onWealthChanged: (d) => state.updateWealth(d),
            ),
          ),
        ),
        Container(width: 1, color: Colors.white12),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildTokensAndStatuses(player),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(GameState state, Player player) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlayerStats(
            player: player,
            onDestinyChanged: (d) => state.updateDestiny(d),
            onStoryChanged: (d) => state.updateStory(d),
            onWealthChanged: (d) => state.updateWealth(d),
          ),
          const SizedBox(height: 16),
          _buildTokensAndStatuses(player),
        ],
      ),
    );
  }

  Widget _buildTokensAndStatuses(Player player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tokens section
        Row(
          children: [
            const Icon(Icons.bolt_rounded,
                color: Color(0xFFD4A574), size: 18),
            const SizedBox(width: 6),
            const Text(
              'SKILLS',
              style: TextStyle(
                color: Color(0xFFD4A574),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _showTokenPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A574).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD4A574).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Color(0xFFD4A574), size: 14),
                    SizedBox(width: 4),
                    Text('Add',
                        style:
                            TextStyle(color: Color(0xFFD4A574), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (player.activeTokenIndices.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              'No skills acquired yet',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: player.activeTokenIndices.map<Widget>((int index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A5C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2E5A8A).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GameConstants.tokenNames[index],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Provider.of<GameState>(context, listen: false)
                            .toggleToken(index);
                      },
                      child: const Icon(Icons.close_rounded,
                          size: 14, color: Colors.white38),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 24),
        // Statuses section
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color(0xFF9B59B6), size: 18),
            const SizedBox(width: 6),
            const Text(
              'STATUSES',
              style: TextStyle(
                color: Color(0xFF9B59B6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _showStatusPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF9B59B6).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Color(0xFF9B59B6), size: 14),
                    SizedBox(width: 4),
                    Text('Add',
                        style:
                            TextStyle(color: Color(0xFF9B59B6), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (player.activeStatusIndices.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            child: const Text(
              'No active statuses',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 13),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: player.activeStatusIndices.map<Widget>((int index) {
              return GestureDetector(
                onTap: () => _showStatusDetails(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B4E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF9B59B6).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 13, color: Color(0xFF9B59B6)),
                      const SizedBox(width: 6),
                      Text(
                        GameConstants.statusNames[index],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
