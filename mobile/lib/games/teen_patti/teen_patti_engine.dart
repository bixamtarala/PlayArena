import 'dart:math';

enum Suit { spades, hearts, diamonds, clubs }

class PlayingCard {
  final int rank; // 2..14 where 14 = Ace
  final Suit suit;
  const PlayingCard(this.rank, this.suit);

  String get rankLabel => switch (rank) { 14 => 'A', 13 => 'K', 12 => 'Q', 11 => 'J', _ => '$rank' };
  String get suitLabel => switch (suit) { Suit.spades => '♠', Suit.hearts => '♥', Suit.diamonds => '♦', Suit.clubs => '♣' };
  String get label => '$rankLabel$suitLabel';
}

class TeenPattiHand {
  final List<PlayingCard> cards;
  const TeenPattiHand(this.cards);

  List<int> get ranks => cards.map((c) => c.rank).toList()..sort((a, b) => b.compareTo(a));
  bool get flush => cards.map((c) => c.suit).toSet().length == 1;
  bool get trail => cards.every((c) => c.rank == cards.first.rank);
  bool get pair => cards.map((c) => c.rank).toSet().length == 2;
  bool get sequence {
    final r = ranks;
    if (r[0] == 14 && r[1] == 3 && r[2] == 2) return true;
    return r[0] - 1 == r[1] && r[1] - 1 == r[2];
  }

  String get category {
    if (trail) return 'Trail / Trio';
    if (sequence && flush) return 'Pure Sequence';
    if (sequence) return 'Sequence';
    if (flush) return 'Color';
    if (pair) return 'Pair';
    return 'High Card';
  }
}

class TeenPattiRound {
  final TeenPattiHand player;
  final TeenPattiHand opponent;
  const TeenPattiRound(this.player, this.opponent);
}

class TeenPattiEngine {
  final Random _random;
  TeenPattiEngine({Random? random}) : _random = random ?? Random.secure();

  TeenPattiRound deal() {
    final deck = <PlayingCard>[
      for (final suit in Suit.values)
        for (var rank = 2; rank <= 14; rank++) PlayingCard(rank, suit),
    ]..shuffle(_random);
    return TeenPattiRound(TeenPattiHand(deck.sublist(0, 3)), TeenPattiHand(deck.sublist(3, 6)));
  }

  int compare(TeenPattiHand a, TeenPattiHand b) {
    final ca = _categoryScore(a), cb = _categoryScore(b);
    if (ca != cb) return ca.compareTo(cb);
    final ar = _tieRanks(a), br = _tieRanks(b);
    for (var i = 0; i < ar.length; i++) {
      if (ar[i] != br[i]) return ar[i].compareTo(br[i]);
    }
    return 0;
  }

  int _categoryScore(TeenPattiHand h) {
    if (h.trail) return 6;
    if (h.sequence && h.flush) return 5;
    if (h.sequence) return 4;
    if (h.flush) return 3;
    if (h.pair) return 2;
    return 1;
  }

  List<int> _tieRanks(TeenPattiHand h) {
    final r = h.ranks;
    if (h.sequence && r[0] == 14 && r[1] == 3 && r[2] == 2) return [3, 2, 1];
    if (h.pair) {
      final counts = <int, int>{};
      for (final rank in r) counts[rank] = (counts[rank] ?? 0) + 1;
      final pairRank = counts.entries.firstWhere((e) => e.value == 2).key;
      final kicker = counts.entries.firstWhere((e) => e.value == 1).key;
      return [pairRank, kicker, 0];
    }
    return r;
  }
}
