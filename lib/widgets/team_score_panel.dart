import 'package:flutter/material.dart';

class TeamRuleValue {
  final String label;
  final int value;
  const TeamRuleValue({required this.label, required this.value});
}

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

  const TeamScorePanel({super.key, required this.teamName, required this.score, required this.color, required this.quickIncrements, required this.rules, required this.onTapIncrement, required this.onDecrement, required this.onQuickIncrement, required this.onNameTap, this.onRuleIncrement, this.onRuleDecrement});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 420;
      final scoreSize = compact ? 70.0 : 106.0;
      return GestureDetector(
        onTap: onTapIncrement,
        onLongPress: onDecrement,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(.18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(.5)),
          ),
          child: SafeArea(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: SingleChildScrollView(child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(onTap: onNameTap, borderRadius: BorderRadius.circular(8), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Text(teamName.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 2)))),
                const SizedBox(height: 10),
                Text('$score', style: TextStyle(color: Colors.white, fontSize: scoreSize, fontWeight: FontWeight.w800, height: .95)),
                const SizedBox(height: 14),
                if (rules.isNotEmpty) Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: rules.map((rule) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: Colors.black.withOpacity(.2), borderRadius: BorderRadius.circular(10)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(rule.label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w700)), const SizedBox(width: 5), InkWell(onTap: () => onRuleDecrement?.call(rule.label, 1), child: const Icon(Icons.remove, size: 13, color: Colors.white70)), Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text('${rule.value}', style: const TextStyle(fontWeight: FontWeight.w800))), InkWell(onTap: () => onRuleIncrement?.call(rule.label, 1), child: const Icon(Icons.add, size: 13, color: Colors.white70))]))).toList()),
                const SizedBox(height: 14),
                Text('Tap to add  •  hold to subtract', style: TextStyle(color: Colors.white.withOpacity(.55), fontSize: 11)),
                if (quickIncrements.length > 1) ...[const SizedBox(height: 10), Wrap(spacing: 6, alignment: WrapAlignment.center, children: quickIncrements.map((inc) => OutlinedButton(onPressed: () => onQuickIncrement(inc), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: color.withOpacity(.7)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), minimumSize: Size.zero), child: Text('+$inc'))).toList())],
              ]),
            )),
          )),
        ),
      );
    });
  }
}
