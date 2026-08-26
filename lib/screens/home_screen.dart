import 'package:flutter/material.dart';
import '../models/sport.dart';
import 'scoreboard_screen.dart';
import 'tennis_scoreboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.scoreboard_outlined,
                      color: Theme.of(context).colorScheme.primary, size: 26),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SCOREBOARD', style: TextStyle(letterSpacing: 2, fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w700)),
                      SizedBox(height: 3),
                      Text('Game day, simplified.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            const Text('Choose your sport', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Keep every score, period, and point clear at a glance.', style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.45)),
            const SizedBox(height: 24),
            ...kSports.map((sport) => _SportTile(
                  icon: sport.icon,
                  color: sport.primaryColor,
                  title: sport.displayName,
                  subtitle: '${sport.periodLabel} · ${sport.totalPeriods} periods',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScoreboardScreen(sport: sport))),
                )),
            _SportTile(
              icon: Icons.sports_tennis,
              color: const Color(0xFF9BBE62),
              title: 'Tennis',
              subtitle: 'Love, 15, 30, 40, deuce',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TennisScoreboard())),
            ),
          ],
        ),
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

  const _SportTile({required this.icon, required this.color, required this.title, required this.onTap, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(width: 5, height: 54, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8))),
              const SizedBox(width: 15),
              CircleAvatar(backgroundColor: color.withOpacity(.18), radius: 24, child: Icon(icon, color: color)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: const TextStyle(color: Colors.white54, fontSize: 13))]])),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
