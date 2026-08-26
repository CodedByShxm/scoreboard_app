import 'package:flutter/material.dart';
import '../models/sport.dart';
import 'scoreboard_screen.dart';
import 'tennis_scoreboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Scoreboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pick a sport',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...kSports.map(
            (sport) => _SportTile(
              icon: sport.icon,
              color: sport.primaryColor,
              title: sport.displayName,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ScoreboardScreen(sport: sport)),
              ),
            ),
          ),
          _SportTile(
            icon: Icons.sports_tennis,
            color: const Color(0xFF33691E),
            title: 'Tennis',
            subtitle: 'Custom scoring: love, 15, 30, 40, deuce',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TennisScoreboard()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SportTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SportTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(color: Colors.white54))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}
