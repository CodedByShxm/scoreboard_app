import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> _pointLabels = ['0', '15', '30', '40'];

class TennisScoreboard extends StatefulWidget {
  const TennisScoreboard({super.key});
  @override State<TennisScoreboard> createState() => _TennisScoreboardState();
}

class _TennisScoreboardState extends State<TennisScoreboard> {
  int _pointsA = 0, _pointsB = 0, _gamesA = 0, _gamesB = 0, _setsA = 0, _setsB = 0;
  String _teamAName = 'Player A', _teamBName = 'Player B';
  @override void initState() { super.initState(); SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]); }
  String _pointLabel(int mine, int theirs) { if (mine >= 3 && theirs >= 3) { if (mine == theirs) return '40'; return mine > theirs ? 'AD' : '—'; } return _pointLabels[mine.clamp(0, 3)]; }
  void _addPoint(bool isA) { setState(() { if (isA) { _pointsA++; } else { _pointsB++; } if (_pointsA >= 4 && _pointsA - _pointsB >= 2) _winGame(true); else if (_pointsB >= 4 && _pointsB - _pointsA >= 2) _winGame(false); }); }
  void _winGame(bool isA) { _pointsA = 0; _pointsB = 0; if (isA) { _gamesA++; } else { _gamesB++; } if ((_gamesA >= 6 && _gamesA - _gamesB >= 2) || _gamesA == 7) _winSet(true); else if ((_gamesB >= 6 && _gamesB - _gamesA >= 2) || _gamesB == 7) _winSet(false); }
  void _winSet(bool isA) { if (isA) _setsA++; else _setsB++; _gamesA = 0; _gamesB = 0; }
  void _reset() => setState(() { _pointsA = 0; _pointsB = 0; _gamesA = 0; _gamesB = 0; _setsA = 0; _setsB = 0; });
  @override void dispose() { SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]); super.dispose(); }
  Future<void> _rename(bool isA) async { final controller = TextEditingController(text: isA ? _teamAName : _teamBName); final result = await showDialog<String>(context: context, builder: (context) => AlertDialog(title: const Text('Player name'), content: TextField(controller: controller, autofocus: true), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Save'))])); if (result != null && result.isNotEmpty) setState(() { if (isA) _teamAName = result; else _teamBName = result; }); }
  Widget _playerColumn({required bool isA}) {
    final name = isA ? _teamAName : _teamBName;
    final points = _pointLabel(isA ? _pointsA : _pointsB, isA ? _pointsB : _pointsA);
    final games = isA ? _gamesA : _gamesB;
    final sets = isA ? _setsA : _setsB;
    final color = isA ? const Color(0xFF3B8D78) : const Color(0xFFB2784B);

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 420 || constraints.maxWidth < 360;
          final scoreSize = isCompact ? 54.0 : 76.0;
          final labelSize = isCompact ? 12.0 : 14.0;

          return GestureDetector(
            onTap: () => _addPoint(isA),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(.22),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(.7)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _rename(isA),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            points,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: scoreSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'GAMES  $games',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: labelSize,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'SETS  $sets',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: labelSize,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Tap anywhere to score',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sports_tennis, color: Color(0xFF9BBE62)),
            SizedBox(width: 8),
            Text('Tennis match'),
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
        children: [_playerColumn(isA: true), _playerColumn(isA: false)],
      ),
    );
  }
}

