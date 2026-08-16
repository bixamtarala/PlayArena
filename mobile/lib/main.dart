import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'teen_patti_screen.dart';
import 'cricket_screen.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabasePublishableKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  }
  runApp(const PlayArenaApp());
}

class PlayArenaApp extends StatelessWidget {
  const PlayArenaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false,title:'PlayArena',theme:ThemeData(useMaterial3:true,brightness:Brightness.dark,colorSchemeSeed:Colors.amber,scaffoldBackgroundColor:const Color(0xFF07131D)),home:const EntryScreen());
}

bool get configured => supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});
  @override Widget build(BuildContext context) {
    if (!configured) return const DemoLoginScreen();
    return Supabase.instance.client.auth.currentSession == null ? const PhoneLoginScreen() : const HomeScreen();
  }
}

class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.sports_esports,size:84,color:Colors.amber),const SizedBox(height:18),Text('PlayArena',style:Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight:FontWeight.bold)),const SizedBox(height:8),const Text('Cricket + Teen Patti',style:TextStyle(fontSize:18)),const SizedBox(height:28),const Text('Development preview',style:TextStyle(color:Colors.amber)),const SizedBox(height:8),const Text('Phone OTP activates later when Supabase is configured.',textAlign:TextAlign.center),const SizedBox(height:24),FilledButton.icon(onPressed:()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomeScreen())),icon:const Icon(Icons.play_arrow),label:const Text('Open Preview'))]))));
}

class PhoneLoginScreen extends StatefulWidget { const PhoneLoginScreen({super.key}); @override State<PhoneLoginScreen> createState()=>_PhoneLoginScreenState(); }
class _PhoneLoginScreenState extends State<PhoneLoginScreen>{final phone=TextEditingController(text:'+91'),otp=TextEditingController();bool sent=false,busy=false;String? error;
Future<void> sendOtp()async{setState((){busy=true;error=null;});try{await Supabase.instance.client.auth.signInWithOtp(phone:phone.text.trim());if(mounted)setState(()=>sent=true);}catch(e){if(mounted)setState(()=>error=e.toString());}finally{if(mounted)setState(()=>busy=false);}}
Future<void> verify()async{setState((){busy=true;error=null;});try{await Supabase.instance.client.auth.verifyOTP(phone:phone.text.trim(),token:otp.text.trim(),type:OtpType.sms);if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomeScreen()));}catch(e){if(mounted)setState(()=>error=e.toString());}finally{if(mounted)setState(()=>busy=false);}}
@override void dispose(){phone.dispose();otp.dispose();super.dispose();}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Sign in')),body:ListView(padding:const EdgeInsets.all(24),children:[const Icon(Icons.phone_android,size:70,color:Colors.amber),const SizedBox(height:20),Text('Enter your mobile number',style:Theme.of(context).textTheme.headlineSmall),const SizedBox(height:20),TextField(controller:phone,keyboardType:TextInputType.phone,decoration:const InputDecoration(labelText:'Mobile number',border:OutlineInputBorder())),if(sent)...[const SizedBox(height:14),TextField(controller:otp,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'OTP',border:OutlineInputBorder()))],if(error!=null)...[const SizedBox(height:12),Text(error!,style:const TextStyle(color:Colors.redAccent))],const SizedBox(height:20),FilledButton(onPressed:busy?null:(sent?verify:sendOtp),child:Text(busy?'Please wait…':sent?'Verify OTP':'Send OTP'))]));}

class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('PlayArena'),actions:[IconButton(onPressed:(){},icon:const Icon(Icons.notifications_none))]),body:ListView(padding:const EdgeInsets.all(18),children:[Card(child:Padding(padding:const EdgeInsets.all(18),child:Row(children:[const CircleAvatar(radius:26,child:Icon(Icons.person)),const SizedBox(width:14),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Welcome, Player',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),Text('Free-play entertainment')])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:const [Text('CHIPS',style:TextStyle(fontSize:11)),Text('10,000',style:TextStyle(color:Colors.amber,fontWeight:FontWeight.bold,fontSize:20)),Text('Admin managed',style:TextStyle(fontSize:10))])]))),const SizedBox(height:18),Text('Choose a game',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),const SizedBox(height:12),GameCard(title:'Teen Patti',subtitle:'Free-play table preview',icon:Icons.style,onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const TeenPattiScreen()))),GameCard(title:'Cricket',subtitle:'2-over batting challenge',icon:Icons.sports_cricket,onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CricketScreen()))),const SizedBox(height:14),const Card(child:Padding(padding:EdgeInsets.all(16),child:Text('Virtual chips are admin-managed entertainment credits. They have no cash value and cannot be withdrawn, sold or redeemed.',textAlign:TextAlign.center))) ]));}

class GameCard extends StatelessWidget{final String title,subtitle;final IconData icon;final VoidCallback onTap;const GameCard({super.key,required this.title,required this.subtitle,required this.icon,required this.onTap});@override Widget build(BuildContext context)=>Card(clipBehavior:Clip.antiAlias,child:InkWell(onTap:onTap,child:Padding(padding:const EdgeInsets.all(20),child:Row(children:[CircleAvatar(radius:30,child:Icon(icon,size:32)),const SizedBox(width:16),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:21)),const SizedBox(height:4),Text(subtitle)])),const Icon(Icons.chevron_right)]))));}
