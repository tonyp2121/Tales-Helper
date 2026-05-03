import 'package:flutter/material.dart';
import '../data/game_constants.dart';
import '../models/player.dart';

class PlayerStats extends StatelessWidget {
  final Player player;
  final ValueChanged<int> onDestinyChanged;
  final ValueChanged<int> onStoryChanged;
  final ValueChanged<int> onWealthChanged;

  const PlayerStats({
    super.key,
    required this.player,
    required this.onDestinyChanged,
    required this.onStoryChanged,
    required this.onWealthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Destiny and Story points
        Row(
          children: [
            Expanded(
              child: _buildPointCard(
                label: 'Destiny',
                value: player.destinyPoints,
                max: GameConstants.maxDestiny,
                color: const Color(0xFFD4A574),
                onDecrement: () => onDestinyChanged(-1),
                onIncrement: () => onDestinyChanged(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPointCard(
                label: 'Story',
                value: player.storyPoints,
                max: GameConstants.maxStory,
                color: const Color(0xFF7EC8E3),
                onDecrement: () => onStoryChanged(-1),
                onIncrement: () => onStoryChanged(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Wealth
        Card(
          color: const Color(0xFF16213E),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Wealth',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      player.wealthName,
                      style: const TextStyle(
                        color: Color(0xFFD4A574),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.white54,
                      onPressed: player.wealth > 0
                          ? () => onWealthChanged(-1)
                          : null,
                    ),
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: player.wealth / 6.0,
                          minHeight: 12,
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _wealthColor(player.wealth),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.white54,
                      onPressed: player.wealth < 6
                          ? () => onWealthChanged(1)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Trade values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTradeChip(
                      icon: Icons.terrain,
                      label: 'Land',
                      value: player.landTradeValue,
                    ),
                    _buildTradeChip(
                      icon: Icons.sailing,
                      label: 'Sea',
                      value: player.seaTradeValue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointCard({
    required String label,
    required int value,
    required int max,
    required Color color,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Card(
      color: const Color(0xFF16213E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Colors.white54,
                  onPressed: value > 0 ? onDecrement : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.white54,
                  onPressed: value < max ? onIncrement : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeChip({
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _wealthColor(int wealth) {
    switch (wealth) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.brown;
      case 2:
        return Colors.orange.shade800;
      case 3:
        return Colors.amber.shade700;
      case 4:
        return Colors.amber;
      case 5:
        return const Color(0xFFD4A574);
      case 6:
        return Colors.amber.shade200;
      default:
        return Colors.grey;
    }
  }
}
