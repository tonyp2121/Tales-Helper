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
                icon: Icons.star_outline_rounded,
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
                icon: Icons.menu_book_outlined,
                onDecrement: () => onStoryChanged(-1),
                onIncrement: () => onStoryChanged(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Wealth
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2838),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD4A574).withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      color: _wealthColor(player.wealth), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Wealth',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _wealthColor(player.wealth).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      player.wealthName,
                      style: TextStyle(
                        color: _wealthColor(player.wealth),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onTap: player.wealth > 0
                        ? () => onWealthChanged(-1)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: player.wealth / 6.0,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _wealthColor(player.wealth),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildCircleButton(
                    icon: Icons.add,
                    onTap: player.wealth < 6
                        ? () => onWealthChanged(1)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Trade values
              Row(
                children: [
                  Expanded(
                    child: _buildTradeChip(
                      icon: Icons.terrain_rounded,
                      label: 'Land',
                      value: player.landTradeValue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTradeChip(
                      icon: Icons.sailing_rounded,
                      label: 'Sea',
                      value: player.seaTradeValue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? const Color(0xFFD4A574).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.03),
          border: Border.all(
            color: onTap != null
                ? const Color(0xFFD4A574).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null
              ? const Color(0xFFD4A574)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildPointCard({
    required String label,
    required int value,
    required int max,
    required Color color,
    required IconData icon,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2838),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color.withValues(alpha: 0.6), size: 16),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 40,
              fontWeight: FontWeight.w200,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircleButton(
                icon: Icons.remove,
                onTap: value > 0 ? onDecrement : null,
              ),
              const SizedBox(width: 20),
              _buildCircleButton(
                icon: Icons.add,
                onTap: value < max ? onIncrement : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeChip({
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const Spacer(),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Color _wealthColor(int wealth) {
    switch (wealth) {
      case 0:
        return Colors.grey.shade500;
      case 1:
        return const Color(0xFF8B6F47);
      case 2:
        return const Color(0xFFCC8833);
      case 3:
        return const Color(0xFFD4A574);
      case 4:
        return const Color(0xFFE8C170);
      case 5:
        return const Color(0xFFF0D9B5);
      case 6:
        return const Color(0xFFFFE4A0);
      default:
        return Colors.grey;
    }
  }
}
