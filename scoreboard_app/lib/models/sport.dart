import 'package:flutter/material.dart';

class SportRuleConfig {
  final String label;
  final int startingValue;
  final int step;

  const SportRuleConfig({
    required this.label,
    this.startingValue = 0,
    this.step = 1,
  });
}

/// Everything that makes one sport's scoreboard look and behave
/// differently from another: colors, icon, scoring increments,
/// and what a "period" is called.
class SportConfig {
  final String displayName;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;

  /// Tap the score to add the first value. Extra buttons are shown
  /// for the rest (e.g. basketball offers +1 / +2 / +3).
  final List<int> quickIncrements;

  final String periodLabel; // "Quarter", "Half", "Set", "Period"...
  final int totalPeriods;
  final bool hasGameClock;
  final int defaultDurationSeconds;
  final List<SportRuleConfig> teamRules;

  const SportConfig({
    required this.displayName,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.quickIncrements,
    required this.periodLabel,
    required this.totalPeriods,
    this.hasGameClock = false,
    this.defaultDurationSeconds = 0,
    this.teamRules = const [],
  });
}

/// Sports handled by the generic scoreboard screen. Add a new entry
/// here to get a new sport with its own colors/rules for free.
const List<SportConfig> kSports = [
  SportConfig(
    displayName: 'Basketball',
    icon: Icons.sports_basketball,
    primaryColor: Color(0xFFE65100),
    accentColor: Color(0xFFFFB74D),
    backgroundColor: Color(0xFF1B1B1F),
    quickIncrements: [1, 2, 3],
    periodLabel: 'Quarter',
    totalPeriods: 4,
    hasGameClock: true,
    defaultDurationSeconds: 12 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'TIMEOUTS', startingValue: 0, step: 1),
    ],
  ),
  SportConfig(
    displayName: 'Soccer',
    icon: Icons.sports_soccer,
    primaryColor: Color(0xFF1B5E20),
    accentColor: Color(0xFF81C784),
    backgroundColor: Color(0xFF0D2B12),
    quickIncrements: [1],
    periodLabel: 'Half',
    totalPeriods: 2,
    hasGameClock: true,
    defaultDurationSeconds: 45 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'CORNERS', startingValue: 0, step: 1),
    ],
  ),
  SportConfig(
    displayName: 'Volleyball',
    icon: Icons.sports_volleyball,
    primaryColor: Color(0xFF0277BD),
    accentColor: Color(0xFF4FC3F7),
    backgroundColor: Color(0xFF0A1F2B),
    quickIncrements: [1],
    periodLabel: 'Set',
    totalPeriods: 5,
    hasGameClock: true,
    defaultDurationSeconds: 15 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'BLOCKS', startingValue: 0, step: 1),
    ],
  ),
  SportConfig(
    displayName: 'Football',
    icon: Icons.sports_football,
    primaryColor: Color(0xFF4A148C),
    accentColor: Color(0xFFBA68C8),
    backgroundColor: Color(0xFF1A0D26),
    quickIncrements: [1, 2, 3, 6],
    periodLabel: 'Quarter',
    totalPeriods: 4,
    hasGameClock: true,
    defaultDurationSeconds: 15 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'PENALTIES', startingValue: 0, step: 1),
    ],
  ),
  SportConfig(
    displayName: 'Hockey',
    icon: Icons.sports_hockey,
    primaryColor: Color(0xFF01579B),
    accentColor: Color(0xFF4DD0E1),
    backgroundColor: Color(0xFF071C26),
    quickIncrements: [1],
    periodLabel: 'Period',
    totalPeriods: 3,
    hasGameClock: true,
    defaultDurationSeconds: 20 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'PIMS', startingValue: 0, step: 1),
    ],
  ),
  SportConfig(
    displayName: 'Generic / Custom',
    icon: Icons.scoreboard,
    primaryColor: Color(0xFF37474F),
    accentColor: Color(0xFF90A4AE),
    backgroundColor: Color(0xFF121212),
    quickIncrements: [1],
    periodLabel: 'Round',
    totalPeriods: 1,
    hasGameClock: true,
    defaultDurationSeconds: 12 * 60,
    teamRules: [
      SportRuleConfig(label: 'FOULS', startingValue: 0, step: 1),
      SportRuleConfig(label: 'KICKS', startingValue: 0, step: 1),
    ],
  ),
];
