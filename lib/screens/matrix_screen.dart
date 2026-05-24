import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/quote_service.dart';
import '../widgets/matrix_rain.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen>
    with SingleTickerProviderStateMixin {
  final QuoteService _quoteService = QuoteService();
  String _currentQuote = '';
  bool _showQuote = false;
  late Timer _quoteTimer;
  late Timer _hideTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scheduleNextQuote();
  }

  void _scheduleNextQuote() {
    _quoteTimer = Timer(
      Duration(seconds: 5 + _random.nextInt(10)),
      () {
        if (mounted) {
          setState(() {
            _currentQuote = _quoteService.getRandomMessage();
            _showQuote = true;
          });
          _hideTimer = Timer(const Duration(seconds: 6), () {
            if (mounted) {
              setState(() => _showQuote = false);
              _scheduleNextQuote();
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _quoteTimer.cancel();
    if (_hideTimer.isActive) _hideTimer.cancel();
    super.dispose();
  }

  void _showNextQuoteNow() {
    if (_hideTimer.isActive) _hideTimer.cancel();
    if (_quoteTimer.isActive) _quoteTimer.cancel();
    setState(() {
      _currentQuote = _quoteService.getRandomMessage();
      _showQuote = true;
    });
    _hideTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() => _showQuote = false);
        _scheduleNextQuote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MatrixRain(
            showQuotes: _showQuote,
            currentQuote: _currentQuote,
            speed: 1.2,
            dropCount: 80,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF00)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _showNextQuoteNow,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00FF00).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Text(
                    '[ TAP FOR NEXT MESSAGE ]',
                    style: TextStyle(
                      color: Color(0xFF00FF00),
                      fontFamily: 'monospace',
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
