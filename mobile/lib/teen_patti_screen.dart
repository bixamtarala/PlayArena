import 'dart:math';
import 'package:flutter/material.dart';
import 'services/teen_patti_engine.dart';

class TeenPattiScreen extends StatefulWidget {
  const TeenPattiScreen({super.key});
  @override
  State<TeenPattiScreen> createState() => _TeenPattiScreenState();
}

class _TeenPattiScreenState extends State<TeenPattiScreen> {
  final _random = Random();
  final List<String> _deck = [
    for (final s in ['♠', '♥', '♦', '♣'])
      for (final r in ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']) '$r$s',
  ];
  List<String> cards = [], bot2 = [], bot3 = [];
  int pot = 30, turnStake = 10;
  bool seen = false, folded = false, finished = false, revealBots = false;
  String status = 'Table ready • Boot 10 chips';

  void deal() {
    final copy = [..._deck]..shuffle(_random);
    setState(() {
      cards = copy.sublist(0, 3);
      bot2 = copy.sublist(3, 6);
      bot3 = copy.sublist(6, 9);
      pot = 30;
      turnStake = 10;
      seen = false;
      folded = false;
      finished = false;
      revealBots = false;
      status = 'Cards dealt • Your turn';
    });
  }

  void seeCards() => setState(() {
        seen = true;
        status = 'Your hand: ${TeenPattiEngine.evaluate(cards).label}';
      });

  void chaal() => setState(() {
        pot += turnStake;
        status = '${seen ? 'Chaal' : 'Blind'}: $turnStake virtual chips • Pot $pot';
      });

  void raise() => setState(() {
        turnStake *= 2;
        pot += turnStake;
        status = 'Raise • Current stake $turnStake';
      });

  void fold() => setState(() {
        folded = true;
        finished = true;
        status = 'You packed • Start a new hand';
      });

  void showdown() {
    if (cards.isEmpty || folded) return;
    final hands = [cards, bot2, bot3];
    var best = 0;
    for (var i = 1; i < hands.length; i++) {
      if (TeenPattiEngine.compare(hands[i], hands[best]) > 0) best = i;
    }
    setState(() {
      finished = true;
      revealBots = true;
      seen = true;
      if (best == 0) {
        status = 'You win the preview showdown • ${TeenPattiEngine.evaluate(cards).label}';
      } else if (best == 1) {
        status = 'Player 2 wins • ${TeenPattiEngine.evaluate(bot2).label}';
      } else {
        status = 'Player 3 wins • ${TeenPattiEngine.evaluate(bot3).label}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teen Patti • Preview')),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _Bot(name: 'Player 2', cards: bot2, reveal: revealBots),
              Column(children: [
                const Text('POT', style: TextStyle(fontSize: 11)),
                Text('$pot', style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
              _Bot(name: 'Player 3', cards: bot3, reveal: revealBots),
            ]),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D5B3B),
                borderRadius: BorderRadius.circular(120),
                border: Border.all(color: Colors.amber.shade700, width: 3),
              ),
              child: Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(status, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)))),
            ),
          ),
          const _Player(name: 'You', chips: 'Admin managed'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards.isEmpty ? [const Text('Tap DEAL to start')] : cards.map((c) => _CardFace(value: seen ? c : '?')).toList(),
          ),
          if (cards.isNotEmpty && seen)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(TeenPattiEngine.evaluate(cards).label, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(spacing: 7, runSpacing: 7, alignment: WrapAlignment.center, children: [
              FilledButton(onPressed: deal, child: Text(finished || cards.isEmpty ? 'DEAL' : 'NEW HAND')),
              OutlinedButton(onPressed: cards.isEmpty || seen || folded || finished ? null : seeCards, child: const Text('SEE')),
              OutlinedButton(onPressed: cards.isEmpty || folded || finished ? null : chaal, child: Text(seen ? 'CHAAL $turnStake' : 'BLIND $turnStake')),
              OutlinedButton(onPressed: cards.isEmpty || folded || finished ? null : raise, child: const Text('RAISE')),
              OutlinedButton(onPressed: cards.isEmpty || folded || finished ? null : showdown, child: const Text('SHOW')),
              OutlinedButton(onPressed: cards.isEmpty || folded || finished ? null : fold, child: const Text('PACK')),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Offline gameplay preview • No cash value • No wallet changes are performed on-device.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
          ),
        ]),
      ),
    );
  }
}

class _Bot extends StatelessWidget {
  final String name;
  final List<String> cards;
  final bool reveal;
  const _Bot({required this.name, required this.cards, required this.reveal});
  @override
  Widget build(BuildContext context) => Column(children: [
        const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        if (cards.isNotEmpty) Text(reveal ? TeenPattiEngine.evaluate(cards).label : '3 cards', style: const TextStyle(fontSize: 10)),
      ]);
}

class _Player extends StatelessWidget {
  final String name, chips;
  const _Player({required this.name, required this.chips});
  @override
  Widget build(BuildContext context) => Column(children: [
        const CircleAvatar(child: Icon(Icons.person)),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(chips, style: const TextStyle(fontSize: 11)),
      ]);
}

class _CardFace extends StatelessWidget {
  final String value;
  const _CardFace({required this.value});
  @override
  Widget build(BuildContext context) {
    final red = value.contains('♥') || value.contains('♦');
    return Container(
      width: 62,
      height: 88,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text(value, style: TextStyle(color: red ? Colors.red : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
