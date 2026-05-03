import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/game_constants.dart';
import '../models/game_state.dart';

class StatusPicker extends StatelessWidget {
  const StatusPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, state, _) {
        final player = state.currentPlayer;
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Statuses',
                    style: TextStyle(
                      color: Color(0xFFD4A574),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: GameConstants.statusNames.length,
                    itemBuilder: (context, index) {
                      final isActive = player.statuses[index];
                      return ListTile(
                        leading: Icon(
                          isActive
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isActive
                              ? const Color(0xFF533483)
                              : Colors.white38,
                        ),
                        title: Text(
                          GameConstants.statusNames[index],
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.white54,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: isActive
                            ? null
                            : Text(
                                GameConstants.statusDescriptions[index]
                                    .split('\n')
                                    .first,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white24,
                                  fontSize: 12,
                                ),
                              ),
                        onTap: () {
                          state.toggleStatus(index);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
