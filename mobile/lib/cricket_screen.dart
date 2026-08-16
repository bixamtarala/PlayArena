import 'dart:math';
import 'package:flutter/material.dart';

class CricketScreen extends StatefulWidget {
  const CricketScreen({super.key});
  @override State<CricketScreen> createState()=>_CricketScreenState();
}

class _CricketScreenState extends State<CricketScreen> {
  final Random _random=Random();
  int runs=0,wickets=0,balls=0,fours=0,sixes=0,dots=0;
  final int maxBalls=12,maxWickets=3;
  String commentary='2-over batting challenge • Tap START';
  bool started=false,finished=false;
  final List<String> recent=[];
  final List<String> timeline=[];

  void start(){setState((){runs=0;wickets=0;balls=0;fours=0;sixes=0;dots=0;started=true;finished=false;recent.clear();timeline.clear();commentary='Match started • Choose your shot';});}

  void playShot(String shot){
    if(!started||finished)return;
    final roll=_random.nextInt(100);int scored=0;bool out=false;
    if(shot=='DEFEND'){if(roll<8){out=true;}else if(roll<55){scored=0;}else if(roll<90){scored=1;}else{scored=2;}}
    else if(shot=='DRIVE'){if(roll<15){out=true;}else if(roll<35){scored=0;}else if(roll<60){scored=1;}else if(roll<82){scored=2;}else{scored=4;}}
    else{if(roll<28){out=true;}else if(roll<45){scored=0;}else if(roll<58){scored=1;}else if(roll<72){scored=2;}else if(roll<90){scored=4;}else{scored=6;}}
    setState((){
      balls++;
      if(out){wickets++;recent.insert(0,'W');commentary='OUT! $shot did not connect';timeline.add('${_ballLabel()}  WICKET • $shot');}
      else{runs+=scored;if(scored==4)fours++;if(scored==6)sixes++;if(scored==0)dots++;recent.insert(0,'$scored');commentary=scored==6?'SIX! Into the stands!':scored==4?'FOUR! Perfect timing!':scored==0?'Dot ball • pressure builds':'$scored run${scored==1?'':'s'}';timeline.add('${_ballLabel()}  $scored run${scored==1?'':'s'} • $shot');}
      if(recent.length>6)recent.removeLast();
      if(balls>=maxBalls||wickets>=maxWickets){finished=true;commentary='INNINGS COMPLETE • $runs/$wickets • Strike rate ${_strikeRate()}';}
    });
  }

  String _oversText()=>'${balls~/6}.${balls%6}';
  String _ballLabel()=>balls==0?'0.0':'${(balls-1)~/6}.${((balls-1)%6)+1}';
  String _strikeRate()=>balls==0?'0.0':(runs*100/balls).toStringAsFixed(1);
  double get progress=>balls/maxBalls;

  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Cricket Arena'),actions:[Padding(padding:const EdgeInsets.only(right:14),child:Center(child:Text('${_oversText()} OV',style:const TextStyle(color:Color(0xFF18D6B0),fontWeight:FontWeight.w900))))]),
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF073A3C),Color(0xFF102B3D)]),borderRadius:BorderRadius.circular(22),border:Border.all(color:const Color(0xFF18D6B0).withValues(alpha:.35))),child:Column(children:[
        Row(children:[const CircleAvatar(backgroundColor:Color(0xFF18D6B0),foregroundColor:Color(0xFF06131F),child:Icon(Icons.sports_cricket)),const SizedBox(width:10),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('PLAYARENA XI',style:TextStyle(fontWeight:FontWeight.w900)),Text('2-over batting challenge',style:TextStyle(fontSize:11,color:Colors.white60))])),Text('$runs/$wickets',style:const TextStyle(fontSize:34,fontWeight:FontWeight.w900,color:Color(0xFFFFB547)))]),
        const SizedBox(height:14),LinearProgressIndicator(value:progress,minHeight:6,borderRadius:BorderRadius.circular(10)),const SizedBox(height:8),Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text('$balls / $maxBalls balls'),Text('${maxWickets-wickets} wickets left')]),
        const Divider(height:26),Text(commentary,textAlign:TextAlign.center,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w700)),
      ])),
      const SizedBox(height:14),
      Row(children:[Expanded(child:_Stat(label:'RUNS',value:'$runs')),const SizedBox(width:8),Expanded(child:_Stat(label:'4s',value:'$fours')),const SizedBox(width:8),Expanded(child:_Stat(label:'6s',value:'$sixes')),const SizedBox(width:8),Expanded(child:_Stat(label:'SR',value:_strikeRate()))]),
      const SizedBox(height:16),
      if(recent.isNotEmpty)...[const Text('CURRENT OVER',style:TextStyle(fontSize:12,fontWeight:FontWeight.w900,color:Colors.white60,letterSpacing:1)),const SizedBox(height:8),Wrap(spacing:8,runSpacing:8,children:recent.reversed.map((r)=>CircleAvatar(radius:20,backgroundColor:r=='W'?Colors.red.shade900:r=='4'||r=='6'?const Color(0xFF0B4B48):const Color(0xFF102B3D),child:Text(r,style:const TextStyle(fontWeight:FontWeight.w900)))).toList()),const SizedBox(height:18)],
      if(!started||finished)FilledButton.icon(onPressed:start,icon:const Icon(Icons.play_arrow),label:Text(finished?'PLAY AGAIN':'START MATCH'))else...[
        const Text('CHOOSE YOUR SHOT',textAlign:TextAlign.center,style:TextStyle(fontSize:13,fontWeight:FontWeight.w900,letterSpacing:1)),const SizedBox(height:10),
        _ShotButton(title:'DEFEND',subtitle:'Safe • low wicket risk',icon:Icons.shield_outlined,onTap:()=>playShot('DEFEND')),
        _ShotButton(title:'DRIVE',subtitle:'Balanced • boundary chance',icon:Icons.sports_cricket,onTap:()=>playShot('DRIVE'),primary:true),
        _ShotButton(title:'POWER',subtitle:'Aggressive • six or wicket',icon:Icons.bolt,onTap:()=>playShot('POWER')),
      ],
      if(timeline.isNotEmpty)...[const SizedBox(height:18),const Text('BALL-BY-BALL',style:TextStyle(fontSize:12,fontWeight:FontWeight.w900,color:Colors.white60,letterSpacing:1)),const SizedBox(height:8),Container(decoration:BoxDecoration(color:const Color(0xFF0B2030),borderRadius:BorderRadius.circular(14)),child:Column(children:timeline.reversed.take(8).map((e)=>ListTile(dense:true,leading:const Icon(Icons.circle,size:8,color:Color(0xFF18D6B0)),title:Text(e))).toList()))],
      if(finished)...[const SizedBox(height:16),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFF102B3D),borderRadius:BorderRadius.circular(14)),child:Column(children:[const Text('MATCH SCORECARD',style:TextStyle(fontWeight:FontWeight.w900)),const SizedBox(height:10),Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[_Mini(label:'Score',value:'$runs/$wickets'),_Mini(label:'Overs',value:_oversText()),_Mini(label:'Dots',value:'$dots'),_Mini(label:'SR',value:_strikeRate())])]))],
      const SizedBox(height:18),const Text('Offline free-play cricket • No cash value • Virtual-chip balance is not changed by gameplay.',textAlign:TextAlign.center,style:TextStyle(fontSize:11,color:Colors.white54)),const SizedBox(height:10),
    ])));
}

class _Stat extends StatelessWidget{final String label,value;const _Stat({required this.label,required this.value});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.symmetric(vertical:12),decoration:BoxDecoration(color:const Color(0xFF102B3D),borderRadius:BorderRadius.circular(12)),child:Column(children:[Text(value,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900,color:Color(0xFFFFB547))),Text(label,style:const TextStyle(fontSize:9,color:Colors.white54))]));}
class _Mini extends StatelessWidget{final String label,value;const _Mini({required this.label,required this.value});@override Widget build(BuildContext context)=>Column(children:[Text(value,style:const TextStyle(fontWeight:FontWeight.w900)),Text(label,style:const TextStyle(fontSize:9,color:Colors.white54))]);}
class _ShotButton extends StatelessWidget{final String title,subtitle;final IconData icon;final VoidCallback onTap;final bool primary;const _ShotButton({required this.title,required this.subtitle,required this.icon,required this.onTap,this.primary=false});@override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Material(color:primary?const Color(0xFF0B4B48):const Color(0xFF102B3D),borderRadius:BorderRadius.circular(13),child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(13),child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[Icon(icon,color:primary?const Color(0xFF18D6B0):Colors.white70),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w900)),Text(subtitle,style:const TextStyle(fontSize:11,color:Colors.white60))])),const Icon(Icons.chevron_right)])))));}
