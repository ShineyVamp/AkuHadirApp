import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:akuhadir/core/services/storage_service.dart';
import 'package:akuhadir/core/theme/app_theme.dart';
import 'package:akuhadir/presentation/providers/attendance_provider.dart';
import 'package:akuhadir/presentation/providers/auth_provider.dart';
import 'package:akuhadir/presentation/providers/history_provider.dart';
import 'package:akuhadir/presentation/providers/theme_provider.dart';
import 'package:akuhadir/presentation/screens/splash/splash_screen.dart';

void main() async {
  DevicePreview.enable();
  await StorageService.init();
  final c = DevicePreview.controller;
  await c.applyPreset(DevicePresets.iPhone16e);
  await c.setOrientation(Orientation.portrait);
  runApp(const AkuHadirApp());
}

class AkuHadirApp extends StatelessWidget {
  const AkuHadirApp({super.key});

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
            title: 'AkuHadir - Presensi PPKD',
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
