import 'package:flutter/material.dart';

const _bg=Color(0xFF06131F),_surface=Color(0xFF102B3D),_teal=Color(0xFF18D6B0),_amber=Color(0xFFFFB547);

class LivePredictionScreen extends StatefulWidget{const LivePredictionScreen({super.key});@override State<LivePredictionScreen> createState()=>_LivePredictionScreenState();}
class _LivePredictionScreenState extends State<LivePredictionScreen>{
 final Map<String,String> picks={};
 final questions=const [
  ('Powerplay Score','India score after 6 overs?',['0–39','40–49','50–59','60+']),
  ('Powerplay Wickets','India wickets after 6 overs?',['0','1','2','3+']),
  ('10 Over Score','India score after 10 overs?',['0–69','70–79','80–89','90+']),
  ('10 Over Wickets','India wickets after 10 overs?',['0–1','2','3','4+']),
  ('15 Over Score','India score after 15 overs?',['0–109','110–129','130–149','150+']),
  ('Final Score','India final innings score?',['0–159','160–179','180–199','200+']),
  ('Top Batter','Highest scorer for India?',['R. Sharma','S. Gill','S. Yadav','Other']),
  ('Match Winner','Who wins the match?',['India','Australia']),
 ];
 void choose(String key,String value){setState(()=>picks[key]=value);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$key prediction saved: $value')));}
 @override Widget build(BuildContext context)=>Scaffold(backgroundColor:_bg,appBar:AppBar(title:const Text('Live Predictions'),actions:[Padding(padding:const EdgeInsets.only(right:14),child:Center(child:Text('${picks.length}/8',style:const TextStyle(color:_amber,fontWeight:FontWeight.w900))))]),body:ListView(padding:const EdgeInsets.all(14),children:[
  Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF073A3C),_surface]),borderRadius:BorderRadius.circular(18),border:Border.all(color:_teal.withValues(alpha:.35))),child:Column(children:[const Row(children:[Container(width:8,height:8,decoration:BoxDecoration(color:Colors.red,shape:BoxShape.circle)),SizedBox(width:7),Text('LIVE • T20',style:TextStyle(color:Colors.redAccent,fontWeight:FontWeight.w900)),Spacer(),Text('DEMO FEED',style:TextStyle(fontSize:9,color:Colors.white54))]),const SizedBox(height:14),const Row(children:[Expanded(child:_Team(name:'INDIA',score:'48/1',overs:'5.2 OV')),Text('VS',style:TextStyle(color:Colors.white38,fontWeight:FontWeight.w900)),Expanded(child:_Team(name:'AUSTRALIA',score:'Yet to bat',overs:'T20'))]),const Divider(height:24),const Text('Powerplay closes in 4 balls',style:TextStyle(color:_amber,fontWeight:FontWeight.w800))])),
  const SizedBox(height:16),const Text('PREDICTION LOBBY',style:TextStyle(fontSize:12,fontWeight:FontWeight.w900,color:_teal,letterSpacing:1)),const SizedBox(height:5),const Text('Choose your cricket predictions before each checkpoint locks.',style:TextStyle(color:Colors.white60,fontSize:12)),const SizedBox(height:10),
  ...questions.map((q)=>_PredictionCard(title:q.$1,question:q.$2,options:q.$3,selected:picks[q.$1],onSelect:(v)=>choose(q.$1,v))),
  Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:_surface,borderRadius:BorderRadius.circular(14)),child:const Column(children:[Icon(Icons.verified_user_outlined,color:_teal),SizedBox(height:6),Text('FREE-PLAY PREDICTION',style:TextStyle(fontWeight:FontWeight.w900)),SizedBox(height:4),Text('Predictions use demo data in this version. No cash betting, withdrawal or redemption. Live feed and server-side settlement will be connected later.',textAlign:TextAlign.center,style:TextStyle(fontSize:10,color:Colors.white54))])),const SizedBox(height:18)
 ]));
}
class _Team extends StatelessWidget{final String name,score,overs;const _Team({required this.name,required this.score,required this.overs});@override Widget build(BuildContext context)=>Column(children:[Text(name,style:const TextStyle(fontWeight:FontWeight.w900)),const SizedBox(height:4),Text(score,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:_amber)),Text(overs,style:const TextStyle(fontSize:9,color:Colors.white54))]);}
class _PredictionCard extends StatelessWidget{final String title,question;final List<String> options;final String? selected;final ValueChanged<String> onSelect;const _PredictionCard({required this.title,required this.question,required this.options,required this.selected,required this.onSelect});@override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:_surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:selected!=null?_teal.withValues(alpha:.45):Colors.white10)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text(title.toUpperCase(),style:const TextStyle(fontSize:10,fontWeight:FontWeight.w900,color:_teal,letterSpacing:.8))),if(selected!=null)const Icon(Icons.check_circle,color:_teal,size:17)]),const SizedBox(height:5),Text(question,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800)),const SizedBox(height:10),Wrap(spacing:7,runSpacing:7,children:options.map((o)=>ChoiceChip(label:Text(o),selected:selected==o,onSelected:(_)=>onSelect(o),selectedColor:const Color(0xFF0B4B48),labelStyle:TextStyle(color:selected==o?_teal:Colors.white70,fontWeight:FontWeight.w700))).toList())]));}
