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
  final bool controlsOnLeft;
  final bool showTeamName;
  final void Function(String label, int delta)? onRuleIncrement;
  final void Function(String label, int delta)? onRuleDecrement;

  const TeamScorePanel({super.key, required this.teamName, required this.score, required this.color, required this.quickIncrements, required this.rules, required this.onTapIncrement, required this.onDecrement, required this.onQuickIncrement, required this.onNameTap, this.controlsOnLeft = false, this.showTeamName = true, this.onRuleIncrement, this.onRuleDecrement});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 420 || constraints.maxHeight < 420;
      final scoreSize = compact ? 72.0 : 108.0;
      final controls = Column(mainAxisSize: MainAxisSize.min, children: [
        _ScoreButton(icon: Icons.add, label: '+ score', color: color, onPressed: onTapIncrement),
        const SizedBox(height: 4),
        _ScoreButton(icon: Icons.remove, label: '− score', color: color.withOpacity(.65), onPressed: onDecrement),
        if (quickIncrements.length > 1) ...quickIncrements.skip(1).map((inc) => Padding(padding: const EdgeInsets.only(top: 4), child: _ScoreButton(icon: Icons.add, label: '+$inc', color: color.withOpacity(.8), onPressed: () => onQuickIncrement(inc)))),
      ]);
      final scoreContent = Column(mainAxisSize: MainAxisSize.min, children: [
        if (showTeamName) InkWell(onTap: onNameTap, child: Padding(padding: const EdgeInsets.all(4), child: Text(teamName.toUpperCase(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.2)))),
        Text('$score', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: scoreSize, fontWeight: FontWeight.w800, height: .95)),
      ]);
      final sideControls = SizedBox(width: 58, child: Align(alignment: controlsOnLeft ? Alignment.centerLeft : Alignment.centerRight, child: controls));
      return Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(.20), borderRadius: BorderRadius.circular(22), border: Border.all(color: color.withOpacity(.65), width: 1.5)), child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Row(children: [if (controlsOnLeft) sideControls, Expanded(child: Center(child: scoreContent)), if (!controlsOnLeft) sideControls]))));
    });
  }
}
class _ScoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool wide;
  const _ScoreButton({required this.icon, required this.label, required this.color, required this.onPressed, this.wide = false});
  @override
  Widget build(BuildContext context) => FilledButton.icon(onPressed: onPressed, icon: Icon(icon, size: 13), label: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .2)), style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: wide ? 8 : 5, vertical: 6), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
}
