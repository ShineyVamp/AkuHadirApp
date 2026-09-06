import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:absendulu/core/services/storage_service.dart';
import 'package:absendulu/core/theme/app_theme.dart';
import 'package:absendulu/presentation/providers/attendance_provider.dart';
import 'package:absendulu/presentation/providers/auth_provider.dart';
import 'package:absendulu/presentation/providers/history_provider.dart';
import 'package:absendulu/presentation/providers/theme_provider.dart';
import 'package:absendulu/presentation/screens/splash/splash_screen.dart';

void main() async {
  DevicePreview.enable();
  await StorageService.init();
  final c = DevicePreview.controller;
  await c.applyPreset(DevicePresets.iPhone16e);
  await c.setOrientation(Orientation.portrait);
  runApp(const absenduluApp());
}

class absenduluApp extends StatelessWidget {
  const absenduluApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'absendulu - Presensi PPKD',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
