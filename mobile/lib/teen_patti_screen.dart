import 'dart:math';
import 'package:flutter/material.dart';
import 'services/teen_patti_engine.dart';

class TeenPattiScreen extends StatefulWidget {
  const TeenPattiScreen({super.key});
  @override State<TeenPattiScreen> createState() => _TeenPattiScreenState();
}

class _TeenPattiScreenState extends State<TeenPattiScreen> {
  final _random = Random();
  final List<String> _deck = [for (final s in ['♠','♥','♦','♣']) for (final r in ['A','K','Q','J','10','9','8','7','6','5','4','3','2']) '$r$s'];
  List<String> cards=[], bot2=[], bot3=[];
  int pot=30, turnStake=10, turn=0, moves=0;
  bool seen=false, folded=false, finished=false, revealBots=false, bot2Folded=false, bot3Folded=false, botBusy=false;
  String status='Table ready • Boot 10 chips';

  void deal(){final copy=[..._deck]..shuffle(_random);setState((){cards=copy.sublist(0,3);bot2=copy.sublist(3,6);bot3=copy.sublist(6,9);pot=30;turnStake=10;turn=0;moves=0;seen=false;folded=false;finished=false;revealBots=false;bot2Folded=false;bot3Folded=false;botBusy=false;status='Your turn • Blind 10';});}
  void seeCards()=>setState((){seen=true;status='Your hand: ${TeenPattiEngine.evaluate(cards).label}';});

  void playerBet({bool raiseBet=false}){
    if(!_canAct){return;}
    setState((){if(raiseBet){turnStake=min(turnStake*2,320);}pot+=turnStake;moves++;status=raiseBet?'You raised to $turnStake':'You played ${seen?'Chaal':'Blind'} $turnStake';turn=1;botBusy=true;});
    _runBots();
  }

  Future<void> _runBots() async {
    for(final bot in [1,2]){
      if(finished){return;}
      if((bot==1&&bot2Folded)||(bot==2&&bot3Folded)){continue;}
      await Future<void>.delayed(const Duration(milliseconds:650));
      if(!mounted){return;}
      final hand=bot==1?bot2:bot3;
      final strength=TeenPattiEngine.evaluate(hand).rank.index;
      final shouldFold=moves>3 && strength<=1 && _random.nextInt(100)<35;
      setState((){
        turn=bot;
        if(shouldFold){
          if(bot==1){bot2Folded=true;}else{bot3Folded=true;}
          status='Player ${bot+1} packed';
        } else {
          final botStake=turnStake;pot+=botStake;moves++;status='Player ${bot+1} played $botStake';
        }
      });
      if(_activePlayers<=1){_finishLastPlayer();return;}
    }
    if(!mounted||finished){return;}
    setState((){turn=0;botBusy=false;status='Your turn • Stake $turnStake';});
    if(moves>=9){showdown();}
  }

  int get _activePlayers=>(folded?0:1)+(bot2Folded?0:1)+(bot3Folded?0:1);
  bool get _canAct=>cards.isNotEmpty&&!folded&&!finished&&!botBusy&&turn==0;

  void fold(){
    if(!_canAct){return;}
    setState((){folded=true;moves++;status='You packed';});
    if(_activePlayers<=1){_finishLastPlayer();}else{setState(()=>botBusy=true);_runBots();}
  }

  void _finishLastPlayer(){setState((){finished=true;revealBots=true;botBusy=false;if(!folded){status='You win • other players packed';}else if(!bot2Folded){status='Player 2 wins';}else{status='Player 3 wins';}});}

  void showdown(){
    if(cards.isEmpty||finished){return;}
    final active=<({int id,List<String> hand})>[];
    if(!folded){active.add((id:0,hand:cards));}
    if(!bot2Folded){active.add((id:1,hand:bot2));}
    if(!bot3Folded){active.add((id:2,hand:bot3));}
    var best=active.first;
    for(final p in active.skip(1)){if(TeenPattiEngine.compare(p.hand,best.hand)>0){best=p;}}
    setState((){finished=true;revealBots=true;seen=true;botBusy=false;status=best.id==0?'You win • ${TeenPattiEngine.evaluate(cards).label}':'Player ${best.id+1} wins • ${TeenPattiEngine.evaluate(best.hand).label}';});
  }

  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Teen Patti • Preview')),body:SafeArea(child:Column(children:[
    Padding(padding:const EdgeInsets.all(10),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[_Bot(name:'Player 2',cards:bot2,reveal:revealBots,folded:bot2Folded,active:turn==1&&!finished),Column(children:[const Text('POT',style:TextStyle(fontSize:11)),Text('$pot',style:const TextStyle(color:Colors.amber,fontSize:24,fontWeight:FontWeight.bold)),Text('Stake $turnStake',style:const TextStyle(fontSize:10))]),_Bot(name:'Player 3',cards:bot3,reveal:revealBots,folded:bot3Folded,active:turn==2&&!finished)])),
    Expanded(child:Container(margin:const EdgeInsets.all(10),decoration:BoxDecoration(color:const Color(0xFF0D5B3B),borderRadius:BorderRadius.circular(120),border:Border.all(color:turn==0&&!finished?Colors.amber:Colors.white24,width:3)),child:Center(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[Text(status,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.bold)),if(botBusy)...[const SizedBox(height:12),const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2))]]))))),
    _Player(name:'You',chips:'Admin managed',active:turn==0&&!finished,folded:folded),const SizedBox(height:8),
    Row(mainAxisAlignment:MainAxisAlignment.center,children:cards.isEmpty?[const Text('Tap DEAL to start')]:cards.map((c)=>_CardFace(value:seen||finished?c:'?')).toList()),
    if(cards.isNotEmpty&&seen)Padding(padding:const EdgeInsets.only(top:6),child:Text(TeenPattiEngine.evaluate(cards).label,style:const TextStyle(color:Colors.amber,fontWeight:FontWeight.bold))),
    const SizedBox(height:10),Padding(padding:const EdgeInsets.symmetric(horizontal:10),child:Wrap(spacing:7,runSpacing:7,alignment:WrapAlignment.center,children:[
      FilledButton(onPressed:botBusy?null:deal,child:Text(finished||cards.isEmpty?'DEAL':'NEW HAND')),
      OutlinedButton(onPressed:!_canAct||seen?null:seeCards,child:const Text('SEE')),
      OutlinedButton(onPressed:_canAct?()=>playerBet():null,child:Text(seen?'CHAAL $turnStake':'BLIND $turnStake')),
      OutlinedButton(onPressed:_canAct?()=>playerBet(raiseBet:true):null,child:const Text('RAISE')),
      OutlinedButton(onPressed:_canAct&&moves>=3?showdown:null,child:const Text('SHOW')),
      OutlinedButton(onPressed:_canAct?fold:null,child:const Text('PACK')),
    ])),
    const Padding(padding:EdgeInsets.all(12),child:Text('Offline gameplay preview • Virtual chips have no cash value • Account balance remains admin-controlled.',textAlign:TextAlign.center,style:TextStyle(fontSize:11))),
  ])));
}

class _Bot extends StatelessWidget{final String name;final List<String> cards;final bool reveal,folded,active;const _Bot({required this.name,required this.cards,required this.reveal,required this.folded,required this.active});@override Widget build(BuildContext context)=>AnimatedContainer(duration:const Duration(milliseconds:250),padding:const EdgeInsets.all(5),decoration:BoxDecoration(border:Border.all(color:active?Colors.amber:Colors.transparent),borderRadius:BorderRadius.circular(12)),child:Column(children:[CircleAvatar(radius:18,child:Icon(folded?Icons.close:Icons.person,size:18)),Text(name,style:const TextStyle(fontSize:11,fontWeight:FontWeight.bold)),if(folded)const Text('PACKED',style:TextStyle(fontSize:9,color:Colors.redAccent))else if(cards.isNotEmpty)Text(reveal?TeenPattiEngine.evaluate(cards).label:'3 cards',style:const TextStyle(fontSize:10))]));}
class _Player extends StatelessWidget{final String name,chips;final bool active,folded;const _Player({required this.name,required this.chips,required this.active,required this.folded});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(5),decoration:BoxDecoration(border:Border.all(color:active?Colors.amber:Colors.transparent),borderRadius:BorderRadius.circular(12)),child:Column(children:[CircleAvatar(child:Icon(folded?Icons.close:Icons.person)),Text(name,style:const TextStyle(fontWeight:FontWeight.bold)),Text(folded?'PACKED':chips,style:TextStyle(fontSize:11,color:folded?Colors.redAccent:null))]));}
class _CardFace extends StatelessWidget{final String value;const _CardFace({required this.value});@override Widget build(BuildContext context){final red=value.contains('♥')||value.contains('♦');return Container(width:62,height:88,margin:const EdgeInsets.symmetric(horizontal:4),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(8)),alignment:Alignment.center,child:Text(value,style:TextStyle(color:red?Colors.red:Colors.black,fontSize:20,fontWeight:FontWeight.bold)));}}
