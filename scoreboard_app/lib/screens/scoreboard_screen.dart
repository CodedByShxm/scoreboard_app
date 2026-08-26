import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/sport.dart';
import '../widgets/team_score_panel.dart';

class ScoreboardScreen extends StatefulWidget {
  final SportConfig sport;
  const ScoreboardScreen({super.key, required this.sport});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  int _scoreA = 0;
  int _scoreB = 0;
  int _period = 1;
  int _gameClockSeconds = 12 * 60;
  bool _isClockRunning = false;
  Timer? _gameClockTimer;
  String _teamAName = 'Home';
  String _teamBName = 'Away';
  late final Map<String, int> _teamARules;
  late final Map<String, int> _teamBRules;

  @override
  void initState() {
    super.initState();
    _gameClockSeconds = widget.sport.defaultDurationSeconds > 0
        ? widget.sport.defaultDurationSeconds
        : 12 * 60;
    _teamARules = {
      for (final rule in widget.sport.teamRules)
        rule.label: rule.startingValue,
    };
    _teamBRules = {
      for (final rule in widget.sport.teamRules)
        rule.label: rule.startingValue,
    };
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  String _formatClock(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleClock() {
    setState(() {
      _isClockRunning = !_isClockRunning;
      if (_isClockRunning) {
        _gameClockTimer?.cancel();
        _gameClockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            if (_gameClockSeconds > 0) {
              _gameClockSeconds--;
            } else {
              _gameClockTimer?.cancel();
              _isClockRunning = false;
            }
          });
        });
      } else {
        _gameClockTimer?.cancel();
      }
    });
  }

  void _adjustClock(int change) {
    if (_isClockRunning) return;
    setState(() {
      _gameClockSeconds = (_gameClockSeconds + change).clamp(0, 60 * 60);
    });
  }

  Future<void> _rename(bool isTeamA) async {
    final controller =
        TextEditingController(text: isTeamA ? _teamAName : _teamBName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Team name'),
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
        if (isTeamA) {
          _teamAName = result;
        } else {
          _teamBName = result;
        }
      });
    }
  }

  void _reset() {
    _gameClockTimer?.cancel();
    setState(() {
      _scoreA = 0;
      _scoreB = 0;
      _period = 1;
      _gameClockSeconds = widget.sport.defaultDurationSeconds > 0
          ? widget.sport.defaultDurationSeconds
          : 12 * 60;
      _isClockRunning = false;
      for (final rule in widget.sport.teamRules) {
        _teamARules[rule.label] = rule.startingValue;
        _teamBRules[rule.label] = rule.startingValue;
      }
    });
  }

  void _updateRule(bool isTeamA, String label, int delta) {
    setState(() {
      final map = isTeamA ? _teamARules : _teamBRules;
      map[label] = (map[label] ?? 0) + delta;
    });
  }

  @override
  void dispose() {
    _gameClockTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sport = widget.sport;
    final hasGameClock = sport.hasGameClock;
    return Scaffold(
      backgroundColor: sport.backgroundColor,
      appBar: AppBar(
        backgroundColor: sport.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Icon(sport.icon, color: sport.accentColor),
            const SizedBox(width: 8),
            Text(sport.displayName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: _reset,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: sport.primaryColor.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.white70),
                  onPressed: () => setState(() {
                    if (_period > 1) _period--;
                  }),
                ),
                Text(
                  '${sport.periodLabel} $_period of ${sport.totalPeriods}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.white70),
                  onPressed: () => setState(() {
                    if (_period < sport.totalPeriods) _period++;
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 760;
                final timerWidth = isCompact ? 120.0 : 180.0;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TeamScorePanel(
                        teamName: _teamAName,
                        score: _scoreA,
                        color: sport.primaryColor,
                        quickIncrements: sport.quickIncrements,
                        rules: sport.teamRules
                            .map((rule) => TeamRuleValue(
                                  label: rule.label,
                                  value: _teamARules[rule.label] ?? rule.startingValue,
                                ))
                            .toList(),
                        onTapIncrement: () =>
                            setState(() => _scoreA += sport.quickIncrements.first),
                        onDecrement: () => setState(() {
                          if (_scoreA > 0) _scoreA -= sport.quickIncrements.first;
                        }),
                        onQuickIncrement: (v) => setState(() => _scoreA += v),
                        onNameTap: () => _rename(true),
                        onRuleIncrement: (label, delta) =>
                            _updateRule(true, label, delta),
                        onRuleDecrement: (label, delta) =>
                            _updateRule(true, label, -delta),
                      ),
                    ),
                    if (hasGameClock)
                      Container(
                        width: timerWidth,
                        color: Colors.black.withOpacity(0.22),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'TIME',
                              style: TextStyle(
                                color: Colors.white70,
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _toggleClock,
                              child: Text(
                                _formatClock(_gameClockSeconds),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => _adjustClock(-15),
                                  icon: const Icon(Icons.remove, color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: _toggleClock,
                                  icon: Icon(
                                    _isClockRunning ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _adjustClock(15),
                                  icon: const Icon(Icons.add, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: TeamScorePanel(
                        teamName: _teamBName,
                        score: _scoreB,
                        color: sport.accentColor,
                        quickIncrements: sport.quickIncrements,
                        rules: sport.teamRules
                            .map((rule) => TeamRuleValue(
                                  label: rule.label,
                                  value: _teamBRules[rule.label] ?? rule.startingValue,
                                ))
                            .toList(),
                        onTapIncrement: () =>
                            setState(() => _scoreB += sport.quickIncrements.first),
                        onDecrement: () => setState(() {
                          if (_scoreB > 0) _scoreB -= sport.quickIncrements.first;
                        }),
                        onQuickIncrement: (v) => setState(() => _scoreB += v),
                        onNameTap: () => _rename(false),
                        onRuleIncrement: (label, delta) =>
                            _updateRule(false, label, delta),
                        onRuleDecrement: (label, delta) =>
                            _updateRule(false, label, -delta),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
