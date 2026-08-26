import 'package:flutter/material.dart';

class TeamRuleValue {
  final String label;
  final int value;

  const TeamRuleValue({
    required this.label,
    required this.value,
  });
}

/// One team's half of the scoreboard. Tap anywhere to add a point,
/// long-press to remove one, tap the team name to rename it.
class TeamScorePanel extends StatelessWidget {
  final String teamName;
  final int score;
  final Color color;
  final List<int> quickIncrements;
  final List<TeamRuleValue> rules;
  final VoidCallback onTapIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onQuickIncrement;
  final VoidCallback onNameTap;
  final void Function(String label, int delta)? onRuleIncrement;
  final void Function(String label, int delta)? onRuleDecrement;

  const TeamScorePanel({
    super.key,
    required this.teamName,
    required this.score,
    required this.color,
    required this.quickIncrements,
    required this.rules,
    required this.onTapIncrement,
    required this.onDecrement,
    required this.onQuickIncrement,
    required this.onNameTap,
    this.onRuleIncrement,
    this.onRuleDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;
        final scoreFontSize = isCompact ? 62.0 : 96.0;

        return GestureDetector(
          onTap: onTapIncrement,
          onLongPress: onDecrement,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withOpacity(0.85), color.withOpacity(0.55)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: LayoutBuilder(
                  builder: (context, inner) {
                    final innerIsCompact = inner.maxHeight < 420;

                    return SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: inner.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: onNameTap,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  teamName.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: innerIsCompact ? 4 : 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$score',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: scoreFontSize,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                            ),
                            SizedBox(height: innerIsCompact ? 8 : 12),
                            if (rules.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: rules.map((rule) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            rule.label,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          GestureDetector(
                                            onTap: () => onRuleDecrement?.call(rule.label, 1),
                                            child: const Icon(Icons.remove, size: 12, color: Colors.white),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            child: Text(
                                              '${rule.value}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => onRuleIncrement?.call(rule.label, 1),
                                            child: const Icon(Icons.add, size: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            const Text(
                              'Tap to add • Hold to subtract',
                              style: TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                            if (quickIncrements.length > 1) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                alignment: WrapAlignment.center,
                                children: quickIncrements.map((inc) {
                                  return OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white70),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                    ),
                                    onPressed: () => onQuickIncrement(inc),
                                    child: Text('+$inc', style: const TextStyle(fontSize: 11)),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
