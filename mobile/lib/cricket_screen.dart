import 'dart:math';
import 'package:flutter/material.dart';

class CricketScreen extends StatefulWidget {
  const CricketScreen({super.key});
  @override
  State<CricketScreen> createState() => _CricketScreenState();
}

class _CricketScreenState extends State<CricketScreen> {
  final Random _random = Random();
  int runs = 0;
  int wickets = 0;
  int balls = 0;
  final int maxBalls = 12;
  final int maxWickets = 3;
  String commentary = '2-over batting challenge • Tap START';
  bool started = false;
  bool finished = false;
  final List<String> recent = [];

  void start() {
    setState(() {
      runs = 0;
      wickets = 0;
      balls = 0;
      started = true;
      finished = false;
      recent.clear();
      commentary = 'Match started • Choose your shot';
    });
  }

  void playShot(String shot) {
    if (!started || finished) return;
    final roll = _random.nextInt(100);
    int scored;
    bool out = false;

    if (shot == 'DEFEND') {
      if (roll < 8) { out = true; scored = 0; }
      else if (roll < 55) { scored = 0; }
      else if (roll < 90) { scored = 1; }
      else { scored = 2; }
    } else if (shot == 'DRIVE') {
      if (roll < 15) { out = true; scored = 0; }
      else if (roll < 35) { scored = 0; }
      else if (roll < 60) { scored = 1; }
      else if (roll < 82) { scored = 2; }
      else { scored = 4; }
    } else {
      if (roll < 28) { out = true; scored = 0; }
      else if (roll < 45) { scored = 0; }
      else if (roll < 58) { scored = 1; }
      else if (roll < 72) { scored = 2; }
      else if (roll < 90) { scored = 4; }
      else { scored = 6; }
    }

    setState(() {
      balls++;
      if (out) {
        wickets++;
        recent.insert(0, 'W');
        commentary = 'OUT! Risky $shot shot';
      } else {
        runs += scored;
        recent.insert(0, '$scored');
        commentary = scored == 6 ? 'SIX! Massive hit!' : scored == 4 ? 'FOUR! Great timing!' : scored == 0 ? 'Dot ball' : '$scored run${scored == 1 ? '' : 's'}';
      }
      if (recent.length > 6) recent.removeLast();
      if (balls >= maxBalls || wickets >= maxWickets) {
        finished = true;
        commentary = 'Innings complete • $runs/$wickets from ${_oversText()} overs';
      }
    });
  }

  String _oversText() => '${balls ~/ 6}.${balls % 6}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cricket • Batting Challenge')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF0D5B3B), borderRadius: BorderRadius.circular(24)),
                child: Column(children: [
                  const Icon(Icons.sports_cricket, size: 56, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text('$runs/$wickets', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                  Text('${_oversText()} overs • $balls/$maxBalls balls'),
                  const SizedBox(height: 14),
                  Text(commentary, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(height: 18),
              if (recent.isNotEmpty) ...[
                const Text('Recent balls', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: recent.map((r) => CircleAvatar(radius: 18, child: Text(r))).toList()),
                const SizedBox(height: 18),
              ],
              if (!started || finished)
                FilledButton.icon(onPressed: start, icon: const Icon(Icons.play_arrow), label: Text(finished ? 'PLAY AGAIN' : 'START MATCH'))
              else ...[
                const Text('Choose shot', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: OutlinedButton(onPressed: () => playShot('DEFEND'), child: const Text('DEFEND'))),
                  const SizedBox(width: 8),
                  Expanded(child: FilledButton(onPressed: () => playShot('DRIVE'), child: const Text('DRIVE'))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton(onPressed: () => playShot('POWER'), child: const Text('POWER'))),
                ]),
                const SizedBox(height: 10),
                const Text('Defend = lower risk • Drive = balanced • Power = higher boundary and wicket chance', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
              ],
              const SizedBox(height: 22),
              const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Offline cricket gameplay preview. Virtual chips are not changed by this game and remain admin-controlled.', textAlign: TextAlign.center))),
            ],
          ),
        ),
      );
}
