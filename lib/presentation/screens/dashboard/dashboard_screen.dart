import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akuhadir/core/constants/app_colors.dart';
import 'package:akuhadir/core/utils/date_formatter.dart';
import 'package:akuhadir/presentation/screens/attendance/gps_verification_screen.dart';
import 'package:akuhadir/presentation/screens/attendance/leave_request_dialog.dart';
import 'package:akuhadir/presentation/providers/attendance_provider.dart';
import 'package:akuhadir/presentation/providers/auth_provider.dart';
import 'package:akuhadir/presentation/providers/theme_provider.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_button.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final attendance = Provider.of<AttendanceProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    final userName = auth.user?.name ?? 'Siswa PPKD';
    final stats = attendance.stats;
    final today = attendance.todayAttendance;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => attendance.initDashboard(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $userName 👋',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormatter.formatIndonesianDate(DateTime.now()),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => theme.toggleTheme(!theme.isDarkMode),
                      icon: Icon(
                        theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NeumorphicCard(
                  borderRadius: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: attendance.isInsideGeofence
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              attendance.isInsideGeofence ? Icons.verified_rounded : Icons.location_off_rounded,
                              size: 16,
                              color: attendance.isInsideGeofence ? AppColors.success : AppColors.danger,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              attendance.isInsideGeofence ? 'Radius PPKD Terverifikasi' : 'Di Luar Jangkauan PPKD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: attendance.isInsideGeofence ? AppColors.success : AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        DateFormatter.formatDisplayTime(attendance.currentTime),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Jarak: ${attendance.distanceToPpkd.toStringAsFixed(0)}m • Kampus PPKD Jakarta',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        isPrimary: true,
                        color: AppColors.primary,
                        height: 56,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GpsVerificationScreen(isCheckIn: true),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Absen Masuk',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: NeumorphicButton(
                        isPrimary: true,
                        color: AppColors.success,
                        height: 56,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GpsVerificationScreen(isCheckIn: false),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Absen Pulang',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                NeumorphicCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.warning),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Berhalangan hadir hari ini?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                                ),
                              ),
                              Text(
                                'Ajukan surat izin atau keterangan sakit',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const LeaveRequestDialog(),
                          );
                        },
                        child: const Text(
                          'Izin',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (today != null) ...[
                  NeumorphicCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status Presensi Hari Ini',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                today.status?.toUpperCase() ?? 'MASUK',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jam Masuk',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                                    ),
                                  ),
                                  Text(
                                    today.effectiveCheckInTime,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jam Pulang',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                                    ),
                                  ),
                                  Text(
                                    today.effectiveCheckOutTime,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'Ringkasan Kehadiran Bulan Ini',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicCard(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Column(
                          children: [
                            Text(
                              '${stats.totalMasuk}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hadir',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${stats.attendancePercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeumorphicCard(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Column(
                          children: [
                            Text(
                              '${stats.totalIzin}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Izin',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Resmi',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeumorphicCard(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Column(
                          children: [
                            Text(
                              '${stats.totalAlfa}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.danger,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Alfa',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tanpa Berita',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NeumorphicCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GpsVerificationScreen(isCheckIn: true),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.school_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pusat Pelatihan Kerja Daerah (PPKD)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Jl. Pemuda No. 30, Rawamangun, Jakarta Timur',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
