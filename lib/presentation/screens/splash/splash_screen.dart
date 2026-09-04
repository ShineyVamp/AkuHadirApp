import 'package:flutter/material.dart';
import 'package:akuhadir/core/constants/app_colors.dart';import 'package:akuhadir/core/services/storage_service.dart';import 'package:akuhadir/core/theme/neumorphic_decorations.dart';import 'package:akuhadir/presentation/screens/auth/login_screen.dart';import 'package:akuhadir/presentation/screens/main/main_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: NeumorphicDecorations.extruded(
                isDark: isDark,
                borderRadius: 28,
              ),
              child: const Center(
                child: Icon(
                  Icons.fingerprint_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AKUHADIR',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sistem Presensi PPKD Jakarta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
