import 'dart:math';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/quote_service.dart';
import 'matrix_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _toggleNotifications() async {
    if (_notificationsEnabled) {
      await _notificationService.cancelAll();
    } else {
      await _notificationService.requestPermissions();
      await _notificationService.showNotification();
      await _notificationService.schedulePeriodicNotifications();
    }
    setState(() => _notificationsEnabled = !_notificationsEnabled);
  }

  Future<void> _showTestNotification() async {
    await _notificationService.showNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundPainter(),
              size: Size.infinite,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 60),
                  _buildGlowButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MatrixScreen(),
                      ),
                    ),
                    label: 'MATRIX EKRANINI OCHISH',
                    icon: Icons.code,
                  ),
                  const SizedBox(height: 20),
                  _buildToggleButton(),
                  const SizedBox(height: 20),
                  _buildTestButton(),
                  const SizedBox(height: 40),
                  _buildStatusCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final alpha = (_glowAnimation.value * 255).toInt();
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Color.fromARGB(alpha, 0, 255, 0),
              const Color(0xFF00FF00),
              Color.fromARGB(alpha, 0, 255, 0),
            ],
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: const Text(
            'MATRIX\nMOTIVATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: Colors.white,
              height: 1.2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowAlpha = (_glowAnimation.value * 80).toInt();
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(glowAlpha, 0, 255, 0),
                blurRadius: 20 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.black),
            label: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF00),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 10,
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton() {
    return ElevatedButton.icon(
      onPressed: _toggleNotifications,
      icon: Icon(
        _notificationsEnabled
            ? Icons.notifications_off
            : Icons.notifications_active,
        color: const Color(0xFF00FF00),
      ),
      label: Text(
        _notificationsEnabled
            ? 'NOTIFICATIONLARNI O\'CHIRISH'
            : 'NOTIFICATIONLARNI YOQISH',
        style: const TextStyle(
          color: Color(0xFF00FF00),
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        side: const BorderSide(color: Color(0xFF00FF00), width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTestButton() {
    return TextButton.icon(
      onPressed: _showTestNotification,
      icon: const Icon(Icons.send, color: Color(0xFF00FF00), size: 18),
      label: const Text(
        'TEST NOTIFICATION YUBORISH',
        style: TextStyle(
          color: Color(0xFF00FF00),
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00FF00).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Column(
        children: [
          const Text(
            'STATUS',
            style: TextStyle(
              color: Color(0xFF00FF00),
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            'Notifications',
            _notificationsEnabled ? 'ACTIVE' : 'INACTIVE',
            _notificationsEnabled ? const Color(0xFF00FF00) : Colors.red,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Matrix Effect',
            'READY',
            const Color(0xFF00FF00),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Platform',
            'Android / PC',
            const Color(0xFF00FF00),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '> $label',
          style: const TextStyle(
            color: Color(0xFF00FF00),
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF00).withOpacity(0.03)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 20) {
      for (double x = 0; x < size.width; x += 20) {
        if (_random.nextDouble() > 0.98) {
          canvas.drawCircle(Offset(x, y), 1, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
