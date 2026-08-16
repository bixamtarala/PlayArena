import 'package:flutter/material.dart';

const _bg = Color(0xFF06131F);
const _surface = Color(0xFF102B3D);
const _teal = Color(0xFF18D6B0);
const _amber = Color(0xFFFFB547);

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool sound = true;
  bool vibration = true;
  bool gameAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF073A3C), _surface]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: _teal,
                  foregroundColor: _bg,
                  child: Icon(Icons.person, size: 36),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Player', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      Text('Development profile', style: TextStyle(color: Colors.white60)),
                      SizedBox(height: 5),
                      Text('10,000 virtual chips', style: TextStyle(color: _amber, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _Label('GAME SETTINGS'),
          SwitchListTile(
            value: sound,
            onChanged: (value) => setState(() => sound = value),
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('Game sounds'),
            subtitle: const Text('Sound effects during gameplay'),
          ),
          SwitchListTile(
            value: vibration,
            onChanged: (value) => setState(() => vibration = value),
            secondary: const Icon(Icons.vibration),
            title: const Text('Vibration'),
            subtitle: const Text('Haptic feedback for game actions'),
          ),
          SwitchListTile(
            value: gameAlerts,
            onChanged: (value) => setState(() => gameAlerts = value),
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Game alerts'),
            subtitle: const Text('Challenges and game updates'),
          ),
          const Divider(),
          const _Label('ACCOUNT'),
          const ListTile(
            leading: Icon(Icons.phone_android),
            title: Text('Mobile number'),
            subtitle: Text('Connect with Supabase later'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Security'),
            subtitle: Text('OTP login and device security'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const _Label('ABOUT'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About PlayArena'),
            subtitle: Text('Version preview'),
          ),
          const ListTile(
            leading: Icon(Icons.policy_outlined),
            title: Text('Fair Play & Virtual Chips'),
            subtitle: Text('No cash value or redemption'),
          ),
          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: _teal,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
