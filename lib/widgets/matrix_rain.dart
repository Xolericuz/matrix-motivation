import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final TextStyle? textStyle;
  final double speed;
  final int dropCount;
  final bool showQuotes;
  final String? currentQuote;

  const MatrixRain({
    super.key,
    this.textStyle,
    this.speed = 1.0,
    this.dropCount = 60,
    this.showQuotes = false,
    this.currentQuote,
  });

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<_RainDrop> _drops = [];
  final Random _random = Random();
  static const String _chars =
      'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.dropCount; i++) {
      _drops.add(_RainDrop(_random));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updateDrops);
  }

  void _updateDrops() {
    setState(() {
      for (final drop in _drops) {
        drop.update(widget.speed);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateDrops);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MatrixRainPainter(
        drops: _drops,
        chars: _chars,
        random: _random,
        textStyle: widget.textStyle,
        showQuotes: widget.showQuotes,
        currentQuote: widget.currentQuote,
      ),
      size: Size.infinite,
    );
  }
}

class _RainDrop {
  double x;
  double y;
  double speed;
  double length;
  double opacity;
  final List<_Char> trail;

  _RainDrop(Random random)
      : x = random.nextDouble(),
        y = random.nextDouble() * -50,
        speed = 2 + random.nextDouble() * 4,
        length = 5 + random.nextDouble() * 15,
        opacity = 0.3 + random.nextDouble() * 0.7,
        trail = [];

  void update(double speedMultiplier) {
    y += speed * speedMultiplier * 0.5;
    trail.add(_Char(
      value: '',
      opacity: 1.0,
    ));
    if (trail.length > length.toInt()) {
      trail.removeAt(0);
    }
    for (int i = 0; i < trail.length; i++) {
      trail[i] = _Char(
        value: trail[i].value,
        opacity: 1.0 - (i / trail.length),
      );
    }
    if (y > 120) {
      y = -10 - _RainDrop._staticRandom.nextDouble() * 20;
      x = _RainDrop._staticRandom.nextDouble();
      speed = 2 + _RainDrop._staticRandom.nextDouble() * 4;
    }
  }

  static final Random _staticRandom = Random();
}

class _Char {
  final String value;
  final double opacity;
  _Char({required this.value, required this.opacity});
}

class _MatrixRainPainter extends CustomPainter {
  final List<_RainDrop> drops;
  final String chars;
  final Random random;
  final TextStyle? textStyle;
  final bool showQuotes;
  final String? currentQuote;

  _MatrixRainPainter({
    required this.drops,
    required this.chars,
    required this.random,
    this.textStyle,
    this.showQuotes = false,
    this.currentQuote,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 80;

    for (final drop in drops) {
      final x = drop.x * size.width;
      final y = drop.y * cellSize;

      for (int i = 0; i < drop.length.toInt(); i++) {
        final char = chars[random.nextInt(chars.length)];
        final alpha = ((1.0 - (i / drop.length)) * 255 * drop.opacity).toInt();
        final isHead = i == 0;

        final paint = Paint()
          ..color = Color.fromARGB(
            alpha.clamp(0, 255),
            isHead ? 220 : 0,
            isHead ? 255 : 180,
            isHead ? 220 : 0,
          );

        final textStyle = TextStyle(
          color: paint.color,
          fontSize: cellSize * (isHead ? 1.2 : 0.9),
          fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
        );

        final tp = TextPainter(
          text: TextSpan(text: char, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(
            canvas, Offset(x, y + (i - drop.length) * cellSize + cellSize));
      }
    }

    if (showQuotes && currentQuote != null && currentQuote!.isNotEmpty) {
      _paintQuote(canvas, size, currentQuote!);
    }
  }

  void _paintQuote(Canvas canvas, Size size, String quote) {
    final lines = _splitQuote(quote, 40);

    final baseFontSize = size.width < 600 ? 16.0 : 24.0;
    final lineHeight = baseFontSize * 1.8;
    final totalHeight = lines.length * lineHeight;
    final startY = (size.height - totalHeight) / 2;

    _paintScanlines(canvas, size);

    for (int i = 0; i < lines.length; i++) {
      final fadeAlpha = ((i + 1) / lines.length * 0.9 + 0.1);
      final charAlpha = (255 * fadeAlpha).toInt();

      final tp = TextPainter(
        text: TextSpan(
          text: lines[i],
          style: TextStyle(
            color: Color.fromARGB(charAlpha.clamp(0, 255), 0, 255, 0),
            fontSize: baseFontSize,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(color: Color(0x8800FF00), blurRadius: 10),
              Shadow(color: Color(0x4400FF00), blurRadius: 20),
            ],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.9);

      tp.paint(
        canvas,
        Offset(
          (size.width - tp.width) / 2,
          startY + i * lineHeight,
        ),
      );
    }
  }

  void _paintScanlines(Canvas canvas, Size size) {
    final scanPaint = Paint()
      ..color = const Color(0x0800FF00)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }
  }

  List<String> _splitQuote(String quote, int maxChars) {
    final words = quote.split(' ');
    final lines = <String>[];
    String current = '';

    for (final word in words) {
      if (current.length + word.length + 1 > maxChars && current.isNotEmpty) {
        lines.add(current);
        current = word;
      } else {
        current = current.isEmpty ? word : '$current $word';
      }
    }
    if (current.isNotEmpty) lines.add(current);
    return lines;
  }

  @override
  bool shouldRepaint(_MatrixRainPainter oldDelegate) => true;
}
