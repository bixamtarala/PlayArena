import 'package:supabase_flutter/supabase_flutter.dart';

class PlayArenaProfile {
  final String id;
  final String displayName;
  final int chipBalance;
  final String role;
  final bool suspended;

  const PlayArenaProfile({required this.id,required this.displayName,required this.chipBalance,required this.role,required this.suspended});

  factory PlayArenaProfile.fromJson(Map<String,dynamic> json)=>PlayArenaProfile(
    id:json['id'] as String,
    displayName:(json['display_name'] as String?)??'Player',
    chipBalance:(json['chip_balance'] as num?)?.toInt()??0,
    role:(json['role'] as String?)??'player',
    suspended:(json['is_suspended'] as bool?)??false,
  );
}

class PlayArenaAccountService {
  final SupabaseClient client;
  PlayArenaAccountService(this.client);

  User? get user=>client.auth.currentUser;

  Future<PlayArenaProfile?> loadProfile() async {
    final current=user;
    if(current==null)return null;
    final row=await client.from('profiles').select().eq('id',current.id).maybeSingle();
    if(row==null)return null;
    return PlayArenaProfile.fromJson(row);
  }

  Future<void> requestChips(int amount,{String? note}) async {
    final current=user;
    if(current==null)throw StateError('Sign in required');
    if(amount<=0)throw ArgumentError.value(amount,'amount','Must be positive');
    await client.from('chip_requests').insert({'user_id':current.id,'requested_chips':amount,'note':note});
  }

  Future<List<Map<String,dynamic>>> loadChipHistory() async {
    final current=user;
    if(current==null)return const [];
    final rows=await client.from('chip_ledger').select().eq('user_id',current.id).order('created_at',ascending:false).limit(50);
    return List<Map<String,dynamic>>.from(rows);
  }
}
