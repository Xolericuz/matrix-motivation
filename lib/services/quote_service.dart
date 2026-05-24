import 'dart:math';
import '../models/quotes.dart';

class QuoteService {
  static final QuoteService _instance = QuoteService._internal();
  factory QuoteService() => _instance;
  QuoteService._internal();

  final Random _random = Random();
  Set<int> _recentIndices = {};
  static const int _maxRecent = 10;

  Quote getRandomQuote() {
    final all = QuotesDatabase.all;
    int index;
    do {
      index = _random.nextInt(all.length);
    } while (_recentIndices.contains(index) && _recentIndices.length < all.length);

    _recentIndices.add(index);
    if (_recentIndices.length > _maxRecent) {
      _recentIndices.remove(_recentIndices.first);
    }
    return all[index];
  }

  String getRandomMessage() {
    final quote = getRandomQuote();
    return quote.text;
  }
}
