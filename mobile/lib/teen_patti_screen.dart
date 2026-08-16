import 'dart:math';
import 'package:flutter/material.dart';

class TeenPattiScreen extends StatefulWidget {
  const TeenPattiScreen({super.key});
  @override State<TeenPattiScreen> createState() => _TeenPattiScreenState();
}

class _TeenPattiScreenState extends State<TeenPattiScreen> {
  final _random = Random();
  final List<String> _deck = [for (final s in ['♠','♥','♦','♣']) for (final r in ['A','K','Q','J','10','9','8','7','6','5','4','3','2']) '$r$s'];
  List<String> cards = [];
  int pot = 30;
  int turnStake = 10;
  bool seen = false;
  bool folded = false;
  String status = 'Table ready • Boot 10 chips';

  void deal() {
    final copy = [..._deck]..shuffle(_random);
    setState(() { cards = copy.take(3).toList(); pot = 30; turnStake = 10; seen = false; folded = false; status = 'Cards dealt • Your turn'; });
  }
  void seeCards() => setState(() { seen = true; status = 'Cards seen • Choose your move'; });
  void chaal() => setState(() { pot += turnStake; status = 'Chaal: $turnStake virtual chips added to pot'; });
  void raise() => setState(() { turnStake *= 2; pot += turnStake; status = 'Raise: stake is now $turnStake'; });
  void fold() => setState(() { folded = true; status = 'You packed this hand'; });

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Teen Patti • Preview')),
    body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const _Player(name:'Player 2', chips:'10K'),
        Column(children:[const Text('POT', style: TextStyle(fontSize:11)), Text('$pot', style: const TextStyle(color:Colors.amber,fontSize:24,fontWeight:FontWeight.bold))]),
        const _Player(name:'Player 3', chips:'10K'),
      ])),
      Expanded(child: Container(margin: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF0D5B3B), borderRadius: BorderRadius.circular(120), border: Border.all(color: Colors.amber.shade700, width: 3)), child: Center(child: Column(mainAxisSize:MainAxisSize.min,children:[
        const Text('PLAYARENA TABLE', style: TextStyle(fontWeight:FontWeight.bold)), const SizedBox(height:12), Text(status, textAlign:TextAlign.center),
      ])))),
      const _Player(name:'You', chips:'Admin managed'),
      const SizedBox(height:10),
      Row(mainAxisAlignment:MainAxisAlignment.center, children: cards.isEmpty ? [const Text('Tap DEAL to start')] : cards.map((c) => _CardFace(value: seen ? c : '?')).toList()),
      const SizedBox(height:12),
      Padding(padding: const EdgeInsets.symmetric(horizontal:12), child: Wrap(spacing:8, runSpacing:8, alignment:WrapAlignment.center, children:[
        FilledButton(onPressed: deal, child: const Text('DEAL')),
        OutlinedButton(onPressed: cards.isEmpty || seen || folded ? null : seeCards, child: const Text('SEE')),
        OutlinedButton(onPressed: cards.isEmpty || folded ? null : chaal, child: Text(seen ? 'CHAAL $turnStake' : 'BLIND $turnStake')),
        OutlinedButton(onPressed: cards.isEmpty || folded ? null : raise, child: const Text('RAISE')),
        OutlinedButton(onPressed: cards.isEmpty || folded ? null : fold, child: const Text('PACK')),
      ])),
      const Padding(padding: EdgeInsets.all(14), child: Text('Preview only • No cash value • Wallet changes are not performed on-device.', textAlign:TextAlign.center, style:TextStyle(fontSize:12))),
    ])),
  );
}

class _Player extends StatelessWidget { final String name,chips; const _Player({required this.name,required this.chips}); @override Widget build(BuildContext context)=>Column(children:[const CircleAvatar(child:Icon(Icons.person)),Text(name,style:const TextStyle(fontWeight:FontWeight.bold)),Text(chips,style:const TextStyle(fontSize:11))]); }
class _CardFace extends StatelessWidget { final String value; const _CardFace({required this.value}); @override Widget build(BuildContext context){final red=value.contains('♥')||value.contains('♦');return Container(width:62,height:88,margin:const EdgeInsets.symmetric(horizontal:4),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(8)),alignment:Alignment.center,child:Text(value,style:TextStyle(color:red?Colors.red:Colors.black,fontSize:20,fontWeight:FontWeight.bold)));}}
