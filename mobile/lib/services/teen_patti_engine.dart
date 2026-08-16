enum TeenPattiRank { highCard, pair, color, sequence, pureSequence, trail }

class TeenPattiHandResult {
  final TeenPattiRank rank;
  final List<int> kickers;
  const TeenPattiHandResult(this.rank, this.kickers);

  String get label => switch (rank) {
    TeenPattiRank.trail => 'Trail',
    TeenPattiRank.pureSequence => 'Pure Sequence',
    TeenPattiRank.sequence => 'Sequence',
    TeenPattiRank.color => 'Color',
    TeenPattiRank.pair => 'Pair',
    TeenPattiRank.highCard => 'High Card',
  };
}

class TeenPattiEngine {
  static int valueOf(String card) {
    final rank = card.substring(0, card.length - 1);
    return switch (rank) {'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, _ => int.parse(rank)};
  }

  static String suitOf(String card) => card.substring(card.length - 1);

  static TeenPattiHandResult evaluate(List<String> cards) {
    if (cards.length != 3) {
      throw ArgumentError('Teen Patti requires exactly 3 cards');
    }
    final values = cards.map(valueOf).toList()..sort((a,b) => b.compareTo(a));
    final suits = cards.map(suitOf).toSet();
    final counts = <int,int>{};
    for (final v in values) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    final flush = suits.length == 1;
    final normalSequence = values[0] - 1 == values[1] && values[1] - 1 == values[2];
    final aceLow = values[0] == 14 && values[1] == 3 && values[2] == 2;
    final sequence = normalSequence || aceLow;
    final sequenceHigh = aceLow ? 3 : values[0];

    if (counts.values.contains(3)) return TeenPattiHandResult(TeenPattiRank.trail, [values[0]]);
    if (flush && sequence) return TeenPattiHandResult(TeenPattiRank.pureSequence, [sequenceHigh]);
    if (sequence) return TeenPattiHandResult(TeenPattiRank.sequence, [sequenceHigh]);
    if (flush) return TeenPattiHandResult(TeenPattiRank.color, values);
    final pair = counts.entries.where((e) => e.value == 2).toList();
    if (pair.isNotEmpty) {
      final pairValue = pair.first.key;
      final kicker = values.firstWhere((v) => v != pairValue);
      return TeenPattiHandResult(TeenPattiRank.pair, [pairValue, kicker]);
    }
    return TeenPattiHandResult(TeenPattiRank.highCard, values);
  }

  static int compare(List<String> a, List<String> b) {
    final x = evaluate(a), y = evaluate(b);
    if (x.rank.index != y.rank.index) return x.rank.index.compareTo(y.rank.index);
    final length = x.kickers.length < y.kickers.length ? x.kickers.length : y.kickers.length;
    for (var i=0;i<length;i++) {
      if (x.kickers[i] != y.kickers[i]) return x.kickers[i].compareTo(y.kickers[i]);
    }
    return 0;
  }
}
