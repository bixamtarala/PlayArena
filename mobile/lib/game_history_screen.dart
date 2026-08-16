import 'package:flutter/material.dart';

const _bg=Color(0xFF06131F),_surface=Color(0xFF102B3D),_teal=Color(0xFF18D6B0),_amber=Color(0xFFFFB547);
class GameHistoryScreen extends StatelessWidget{
 const GameHistoryScreen({super.key});
 @override Widget build(BuildContext context){
  const games=[
   ('Cricket','2-Over Batting Challenge','42/2','Completed','Today • 6:20 PM',Icons.sports_cricket),
   ('Teen Patti','3-Card Table','Won','Completed','Today • 6:05 PM',Icons.style),
   ('Cricket','2-Over Batting Challenge','31/3','Completed','Yesterday • 9:14 PM',Icons.sports_cricket),
   ('Teen Patti','3-Card Table','Packed','Completed','Yesterday • 8:52 PM',Icons.style),
  ];
  return Scaffold(backgroundColor:_bg,appBar:AppBar(title:const Text('Game History')),body:ListView(padding:const EdgeInsets.all(16),children:[
   Row(children:[Expanded(child:_Summary(label:'GAMES',value:'4')),const SizedBox(width:8),Expanded(child:_Summary(label:'CRICKET',value:'2')),const SizedBox(width:8),Expanded(child:_Summary(label:'TEEN PATTI',value:'2'))]),
   const SizedBox(height:18),const Text('RECENT ACTIVITY',style:TextStyle(fontSize:12,fontWeight:FontWeight.w900,color:Colors.white60,letterSpacing:1)),const SizedBox(height:8),
   ...games.map((g)=>Container(margin:const EdgeInsets.only(bottom:9),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:_surface,borderRadius:BorderRadius.circular(14)),child:Row(children:[CircleAvatar(backgroundColor:const Color(0xFF0B4B48),child:Icon(g.$6,color:_teal)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(g.$1,style:const TextStyle(fontWeight:FontWeight.w900)),Text(g.$2,style:const TextStyle(fontSize:11,color:Colors.white60)),const SizedBox(height:4),Text(g.$5,style:const TextStyle(fontSize:10,color:Colors.white38))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(g.$3,style:const TextStyle(color:_amber,fontWeight:FontWeight.w900)),Text(g.$4,style:const TextStyle(fontSize:9,color:_teal))])]))),
   const SizedBox(height:8),const Text('Preview history uses local demo data. Database-backed history will be connected later.',textAlign:TextAlign.center,style:TextStyle(fontSize:10,color:Colors.white38))
  ]));
 }
}
class _Summary extends StatelessWidget{final String label,value;const _Summary({required this.label,required this.value});@override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.symmetric(vertical:14),decoration:BoxDecoration(color:_surface,borderRadius:BorderRadius.circular(12)),child:Column(children:[Text(value,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:_amber)),Text(label,style:const TextStyle(fontSize:9,color:Colors.white54))]));}
