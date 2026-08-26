import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> _pointLabels = ['0', '15', '30', '40'];

/// Tennis doesn't fit the generic "add a point" model: points reset
/// into games, games reset into sets, and 40-40 becomes deuce/ad.
/// So it gets its own screen instead of using SportConfig.
class TennisScoreboard extends StatefulWidget {
  const TennisScoreboard({super.key});

  @override
  State<TennisScoreboard> createState() => _TennisScoreboardState();
}

class _TennisScoreboardState extends State<TennisScoreboard> {
  int _pointsA = 0;
  int _pointsB = 0;
  int _gamesA = 0;
  int _gamesB = 0;
  int _setsA = 0;
  int _setsB = 0;
  String _teamAName = 'Player A';
  String _teamBName = 'Player B';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  String _pointLabel(int mine, int theirs) {
    if (mine >= 3 && theirs >= 3) {
      if (mine == theirs) return '40';
      return mine > theirs ? 'AD' : '—';
    }
    return _pointLabels[mine.clamp(0, 3)];
  }

  void _addPoint(bool isA) {
    setState(() {
      if (isA) {
        _pointsA++;
      } else {
        _pointsB++;
      }
      if (_pointsA >= 4 && _pointsA - _pointsB >= 2) {
        _winGame(true);
      } else if (_pointsB >= 4 && _pointsB - _pointsA >= 2) {
        _winGame(false);
      }
    });
  }

  void _winGame(bool isA) {
    _pointsA = 0;
    _pointsB = 0;
    if (isA) {
      _gamesA++;
    } else {
      _gamesB++;
    }
    if ((_gamesA >= 6 && _gamesA - _gamesB >= 2) || _gamesA == 7) {
      _winSet(true);
    } else if ((_gamesB >= 6 && _gamesB - _gamesA >= 2) || _gamesB == 7) {
      _winSet(false);
    }
  }

  void _winSet(bool isA) {
    if (isA) {
      _setsA++;
    } else {
      _setsB++;
    }
    _gamesA = 0;
    _gamesB = 0;
  }

  void _reset() {
    setState(() {
      _pointsA = 0;
      _pointsB = 0;
      _gamesA = 0;
      _gamesB = 0;
      _setsA = 0;
      _setsB = 0;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _rename(bool isA) async {
    final controller =
        TextEditingController(text: isA ? _teamAName : _teamBName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Player name'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        if (isA) {
          _teamAName = result;
        } else {
          _teamBName = result;
        }
      });
    }
  }

  Widget _playerColumn({required bool isA}) {
    final name = isA ? _teamAName : _teamBName;
    final points = _pointLabel(
        isA ? _pointsA : _pointsB, isA ? _pointsB : _pointsA);
    final games = isA ? _gamesA : _gamesB;
    final sets = isA ? _setsA : _setsB;

    return Expanded(
      child: GestureDetector(
        onTap: () => _addPoint(isA),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: isA ? const Color(0xFF33691E) : const Color(0xFF827717),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _rename(isA),
                  child: Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  points,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Games: $games',
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                Text('Sets: $sets',
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 12),
                const Text('Tap to score a point',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2E0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2E0F),
        title: const Row(
          children: [
            Icon(Icons.sports_tennis, color: Color(0xFFD4E157)),
            SizedBox(width: 8),
            Text('Tennis'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset match',
            onPressed: _reset,
          ),
        ],
      ),
      body: Row(
        children: [
          _playerColumn(isA: true),
          Container(width: 2, color: Colors.white24),
          _playerColumn(isA: false),
        ],
      ),
    );
  }
}
