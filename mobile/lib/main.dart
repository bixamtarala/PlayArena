import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

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
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PlayArena',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF18D6B0), brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF06131F),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFF0B2030), indicatorColor: Color(0xFF0B4B48)),
    ),
    home: const EntryScreen(),
  );
}

bool get configured => supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if (!configured) return const DemoLoginScreen();
    return Supabase.instance.client.auth.currentSession == null ? const PhoneLoginScreen() : const HomeScreen();
  }
}

class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.sports_esports, size: 84, color: Color(0xFF18D6B0)),
          const SizedBox(height: 18),
          Text('PlayArena', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Cricket + Teen Patti', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 28),
          const Text('Development Preview', style: TextStyle(color: Color(0xFF18D6B0), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Supabase login will be activated after the gameplay and dashboard are approved.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())), icon: const Icon(Icons.play_arrow), label: const Text('OPEN PLAYARENA')),
        ]),
      ),
    ),
  );
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phone = TextEditingController(text: '+91');
  final otp = TextEditingController();
  bool sent = false, busy = false;
  String? error;

  Future<void> sendOtp() async {
    setState(() { busy = true; error = null; });
    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: phone.text.trim());
      if (mounted) setState(() => sent = true);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> verify() async {
    setState(() { busy = true; error = null; });
    try {
      await Supabase.instance.client.auth.verifyOTP(phone: phone.text.trim(), token: otp.text.trim(), type: OtpType.sms);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override void dispose() { phone.dispose(); otp.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sign in')),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.phone_android, size: 70, color: Color(0xFF18D6B0)),
      const SizedBox(height: 20),
      Text('Enter your mobile number', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 20),
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', border: OutlineInputBorder())),
      if (sent) ...[const SizedBox(height: 14), TextField(controller: otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP', border: OutlineInputBorder()))],
      if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: Colors.redAccent))],
      const SizedBox(height: 20),
      FilledButton(onPressed: busy ? null : (sent ? verify : sendOtp), child: Text(busy ? 'Please wait…' : sent ? 'Verify OTP' : 'Send OTP')),
    ]),
  );
}
