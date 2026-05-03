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
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Consumer<GameState>(
          builder: (context, state, _) {
            final player = state.currentPlayer;
            return Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: player.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: player.color == Colors.black
                          ? Colors.white54
                          : Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  player.name,
                  style: TextStyle(
                    color: player.color == Colors.black
                        ? Colors.white
                        : player.color == Colors.white
                            ? Colors.white
                            : player.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Player ${state.currentPlayerIndex + 1} of ${state.playerCount}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            onPressed: _confirmNewGame,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: AnimatedBuilder(
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
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 700) {
                    return _buildWideLayout(state, player);
                  }
                  return _buildNarrowLayout(state, player);
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF16213E),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openEncounter,
                  icon: const Icon(Icons.search),
                  label: const Text('Encounter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3460),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _nextPlayer,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Player'),
                ),
              ),
            ],
          ),
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
            const Text(
              'Skills',
              style: TextStyle(
                color: Color(0xFFD4A574),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: Color(0xFFD4A574)),
              onPressed: _showTokenPicker,
              tooltip: 'Add Skill',
            ),
          ],
        ),
        if (player.activeTokenIndices.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No skills yet. Tap + to add.',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: player.activeTokenIndices.map<Widget>((int index) {
              return Chip(
                label: Text(
                  GameConstants.tokenNames[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: const Color(0xFF0F3460),
                deleteIcon:
                    const Icon(Icons.close, size: 16, color: Colors.white54),
                onDeleted: () {
                  Provider.of<GameState>(context, listen: false)
                      .toggleToken(index);
                },
              );
            }).toList(),
          ),
        const SizedBox(height: 20),
        // Statuses section
        Row(
          children: [
            const Text(
              'Statuses',
              style: TextStyle(
                color: Color(0xFFD4A574),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: Color(0xFFD4A574)),
              onPressed: _showStatusPicker,
              tooltip: 'Add Status',
            ),
          ],
        ),
        if (player.activeStatusIndices.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No active statuses. Tap + to add.',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: player.activeStatusIndices.map<Widget>((int index) {
              return ActionChip(
                label: Text(
                  GameConstants.statusNames[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: const Color(0xFF533483),
                avatar:
                    const Icon(Icons.info_outline, size: 16, color: Colors.white54),
                onPressed: () => _showStatusDetails(index),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
