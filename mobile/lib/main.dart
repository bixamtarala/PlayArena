import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
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
          colorSchemeSeed: Colors.amber,
          scaffoldBackgroundColor: const Color(0xFF07131D),
        ),
        home: const EntryScreen(),
      );
}

bool get configured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if (!configured) return const DemoLoginScreen();
    final session = Supabase.instance.client.auth.currentSession;
    return session == null ? const PhoneLoginScreen() : const HomeScreen();
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
              const Icon(Icons.sports_esports, size: 84, color: Colors.amber),
              const SizedBox(height: 18),
              Text('PlayArena', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Cricket + Teen Patti', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 28),
              const Text('Development preview', style: TextStyle(color: Colors.amber)),
              const SizedBox(height: 8),
              const Text('Phone OTP activates when Supabase credentials are configured. No secrets are stored in GitHub.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())), icon: const Icon(Icons.play_arrow), label: const Text('Open Preview')),
            ]),
          ),
        ),
      );
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
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
    } catch (e) { if (mounted) setState(() => error = e.toString()); }
    finally { if (mounted) setState(() => busy = false); }
  }

  Future<void> verify() async {
    setState(() { busy = true; error = null; });
    try {
      await Supabase.instance.client.auth.verifyOTP(phone: phone.text.trim(), token: otp.text.trim(), type: OtpType.sms);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) { if (mounted) setState(() => error = e.toString()); }
    finally { if (mounted) setState(() => busy = false); }
  }

  @override
  void dispose() { phone.dispose(); otp.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          const Icon(Icons.phone_android, size: 70, color: Colors.amber),
          const SizedBox(height: 20),
          Text('Enter your mobile number', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('We will send an OTP to verify your number.'),
          const SizedBox(height: 20),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '+919876543210', border: OutlineInputBorder())),
          if (sent) ...[const SizedBox(height: 14), TextField(controller: otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP', border: OutlineInputBorder()))],
          if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: Colors.redAccent))],
          const SizedBox(height: 20),
          FilledButton(onPressed: busy ? null : (sent ? verify : sendOtp), child: Text(busy ? 'Please wait…' : sent ? 'Verify OTP' : 'Send OTP')),
        ]),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('PlayArena'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))]),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
            const CircleAvatar(radius: 26, child: Icon(Icons.person)), const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Welcome, Player', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('Free-play entertainment')])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [Text('CHIPS', style: TextStyle(fontSize: 11)), Text('10,000', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20))]),
          ]))),
          const SizedBox(height: 18),
          Text('Choose a game', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GameCard(title: 'Teen Patti', subtitle: 'Classic multiplayer card game', icon: Icons.style, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Teen Patti')))),
          GameCard(title: 'Cricket', subtitle: 'Cricket challenges and gameplay', icon: Icons.sports_cricket, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Cricket')))),
          const SizedBox(height: 14),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Virtual chips are for entertainment only. They have no cash value and cannot be withdrawn, sold or redeemed.', textAlign: TextAlign.center))),
        ]),
      );
}

class GameCard extends StatelessWidget {
  final String title, subtitle; final IconData icon; final VoidCallback onTap;
  const GameCard({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [CircleAvatar(radius: 30, child: Icon(icon, size: 32)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)), const SizedBox(height: 4), Text(subtitle)])), const Icon(Icons.chevron_right)]))));
}

class ComingSoonScreen extends StatelessWidget {
  final String title; const ComingSoonScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.construction, size: 72, color: Colors.amber), const SizedBox(height: 16), Text('$title engine is the next build', style: Theme.of(context).textTheme.titleLarge)])));
}
