import 'package:flutter_test/flutter_test.dart';
import 'package:playarena/services/teen_patti_engine.dart';

void main() {
  test('recognizes standard Teen Patti hand categories', () {
    expect(TeenPattiEngine.evaluate(['A♠','A♥','A♦']).rank, TeenPattiRank.trail);
    expect(TeenPattiEngine.evaluate(['A♠','K♠','Q♠']).rank, TeenPattiRank.pureSequence);
    expect(TeenPattiEngine.evaluate(['9♠','8♥','7♦']).rank, TeenPattiRank.sequence);
    expect(TeenPattiEngine.evaluate(['A♣','9♣','4♣']).rank, TeenPattiRank.color);
    expect(TeenPattiEngine.evaluate(['K♠','K♥','3♦']).rank, TeenPattiRank.pair);
    expect(TeenPattiEngine.evaluate(['A♠','10♥','4♦']).rank, TeenPattiRank.highCard);
  });

  test('trail beats pure sequence', () {
    expect(TeenPattiEngine.compare(['7♠','7♥','7♦'], ['A♠','K♠','Q♠']), greaterThan(0));
  });

  test('pair comparison uses pair value then kicker', () {
    expect(TeenPattiEngine.compare(['Q♠','Q♥','2♦'], ['J♠','J♥','A♦']), greaterThan(0));
  });

  test('A-3-2 is recognized as a sequence', () {
    expect(TeenPattiEngine.evaluate(['A♠','3♥','2♦']).rank, TeenPattiRank.sequence);
  });
}
