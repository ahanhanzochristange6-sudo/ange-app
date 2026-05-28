import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _glow = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
    Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pulse(
              infinite: true,
              duration: const Duration(milliseconds: 1500),
              child: AnimatedBuilder(
                animation: _glow,
                builder: (context, child) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.fireRed.withOpacity(0.6), blurRadius: _glow.value, spreadRadius: _glow.value * 0.4),
                      BoxShadow(color: AppTheme.gold.withOpacity(0.3), blurRadius: _glow.value * 1.5, spreadRadius: _glow.value * 0.2),
                    ],
                  ),
                  child: Image.asset('assets/images/logo.png', width: 220, height: 220),
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.fireRed, AppTheme.gold],
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: const Text(
                  'ANGE',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 8, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: Text(
                'LECTEUR MULTIMÉDIA ULTIME',
                style: TextStyle(fontSize: 12, letterSpacing: 4, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
