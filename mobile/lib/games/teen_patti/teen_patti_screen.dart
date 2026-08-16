import 'package:flutter/material.dart';
import 'teen_patti_engine.dart';

class TeenPattiScreen extends StatefulWidget {
  const TeenPattiScreen({super.key});
  @override
  State<TeenPattiScreen> createState() => _TeenPattiScreenState();
}

class _TeenPattiScreenState extends State<TeenPattiScreen> {
  final engine = TeenPattiEngine();
  TeenPattiRound? round;
  bool revealOpponent = false;
  String status = 'Tap Deal to start a free-play round';

  void deal() => setState(() {
        round = engine.deal();
        revealOpponent = false;
        status = 'Cards dealt • Choose Show to compare hands';
      });

  void show() {
    if (round == null) return;
    final result = engine.compare(round!.player, round!.opponent);
    setState(() {
      revealOpponent = true;
      status = result > 0 ? 'You win this round!' : result < 0 ? 'Opponent wins this round' : 'Round tied';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Teen Patti • Free Play')),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF063A2C), Color(0xFF07131D)]),
          ),
          child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(18), children: [
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('TABLE 01', style: TextStyle(color: Colors.white70)),
                Chip(label: Text('Virtual chips • admin managed')),
              ]),
              const SizedBox(height: 24),
              const Center(child: CircleAvatar(radius: 28, child: Icon(Icons.smart_toy))),
              const Center(child: Padding(padding: EdgeInsets.only(top: 6), child: Text('Opponent'))),
              const SizedBox(height: 12),
              _HandView(hand: round?.opponent, hidden: !revealOpponent),
              const SizedBox(height: 28),
              Card(color: Colors.black26, child: Padding(padding: const EdgeInsets.all(14), child: Text(status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 28),
              const Center(child: CircleAvatar(radius: 28, child: Icon(Icons.person))),
              const Center(child: Padding(padding: EdgeInsets.only(top: 6), child: Text('You'))),
              const SizedBox(height: 12),
              _HandView(hand: round?.player, hidden: false),
              if (round != null) Center(child: Padding(padding: const EdgeInsets.only(top: 8), child: Text(round!.player.category, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: OutlinedButton.icon(onPressed: deal, icon: const Icon(Icons.refresh), label: Text(round == null ? 'Deal' : 'New Round'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton.icon(onPressed: round == null || revealOpponent ? null : show, icon: const Icon(Icons.visibility), label: const Text('Show'))),
              ]),
              const SizedBox(height: 18),
              const Text('Preview rules: cards are dealt locally for gameplay testing. No cash, purchase, withdrawal, transfer or prize redemption is available.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
          ),
        ),
      );
}

class _HandView extends StatelessWidget {
  final TeenPattiHand? hand;
  final bool hidden;
  const _HandView({required this.hand, required this.hidden});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final card = hand == null ? null : hand!.cards[i];
          final red = card?.suit == Suit.hearts || card?.suit == Suit.diamonds;
          return Container(
            width: 70,
            height: 96,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: hidden || card == null ? const Color(0xFF9A1C2F) : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white54, width: 2)),
            child: Center(child: hidden || card == null ? const Icon(Icons.casino, color: Colors.white, size: 34) : Text(card.label, style: TextStyle(color: red ? Colors.red : Colors.black, fontWeight: FontWeight.bold, fontSize: 24))),
          );
        }),
      );
}
