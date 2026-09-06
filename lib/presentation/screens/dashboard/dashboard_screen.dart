import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:absendulu/core/constants/app_colors.dart';
import 'package:absendulu/core/theme/neumorphic_decorations.dart';
import 'package:absendulu/core/utils/date_formatter.dart';
import 'package:absendulu/extensions/navigation.dart';
import 'package:absendulu/presentation/screens/attendance/gps_verification_screen.dart';
import 'package:absendulu/presentation/screens/attendance/leave_request_dialog.dart';
import 'package:absendulu/presentation/providers/attendance_provider.dart';
import 'package:absendulu/presentation/providers/auth_provider.dart';
import 'package:absendulu/presentation/providers/theme_provider.dart';
import 'package:absendulu/presentation/widgets/neumorphic_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final attendance = Provider.of<AttendanceProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final double fontScale = screenWidth < 360
        ? 0.86
        : (screenWidth < 400 ? 0.94 : 1.0);

    final userName = auth.user?.name ?? 'Siswa PPKD';
    final stats = attendance.stats;
    final today = attendance.todayAttendance;

    final isIzin = today != null && today.isIzin;
    final hasCheckedIn = today != null && today.isCheckedIn;
    final hasCheckedOut = today != null && today.isCheckedOut;
    final isLate =
        attendance.currentTime.hour > 8 ||
        (attendance.currentTime.hour == 8 &&
            (attendance.currentTime.minute > 0 ||
                attendance.currentTime.second > 0));

    Color buttonColor;
    String mainButtonText = 'Absen';
    String subButtonText;
    bool isCheckInAction = true;

    if (isIzin) {
      buttonColor = AppColors.warning;
      mainButtonText = 'Izin';
      subButtonText = 'SEDANG IZIN';
    } else if (!hasCheckedIn) {
      isCheckInAction = true;
      if (isLate) {
        buttonColor = const Color(0xFFF59E0B);
        mainButtonText = 'Absen';
        subButtonText = 'TERLAMBAT';
      } else {
        buttonColor = const Color(0xFF2C54D8);
        mainButtonText = 'Absen';
        subButtonText = 'ABSEN MASUK';
      }
    } else if (!hasCheckedOut) {
      isCheckInAction = false;
      buttonColor = Colors.redAccent;
      mainButtonText = 'Pulang';
      subButtonText = 'ABSEN PULANG';
    } else {
      buttonColor = const Color(0xFF64748B);
      mainButtonText = 'Selesai';
      subButtonText = 'SUDAH PULANG';
    }

    void handleAttendanceTap() async {
      await context.push(
        GpsVerificationScreen(isCheckIn: isCheckInAction),
      );
      await attendance.loadTodayAttendance();
      await attendance.loadStats();
    }

    final hourMinuteStr = DateFormat('HH:mm').format(attendance.currentTime);
    final secondStr = DateFormat('ss').format(attendance.currentTime);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => attendance.initDashboard(),
          color: AppColors.primary,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
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
                                  fontSize: 20 * fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textHighDark
                                      : AppColors.textHigh,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatIndonesianDate(
                                  DateTime.now(),
                                ),
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: isDark
                                      ? AppColors.textMediumDark
                                      : AppColors.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => theme.toggleTheme(!theme.isDarkMode),
                          icon: Icon(
                            theme.isDarkMode
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    NeumorphicCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 22,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: attendance.isInsideGeofence
                                  ? (isDark
                                        ? const Color(
                                            0xFF064E3B,
                                          ).withValues(alpha: 0.4)
                                        : const Color(0xFFE6F8F0))
                                  : (isDark
                                        ? const Color(
                                            0xFF7F1D1D,
                                          ).withValues(alpha: 0.4)
                                        : const Color(0xFFFEF2F2)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: attendance.isInsideGeofence
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    attendance.isInsideGeofence
                                        ? 'Lokasi Sesuai: Radius ${attendance.distanceToPpkd.toStringAsFixed(0)}m dari PPKD Jakpus'
                                        : 'Di Luar Radius: ${attendance.distanceToPpkd.toStringAsFixed(0)}m dari PPKD Jakpus (Maks 300m)',
                                    style: TextStyle(
                                      fontSize: 12 * fontScale,
                                      fontWeight: FontWeight.w700,
                                      color: attendance.isInsideGeofence
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                hourMinuteStr,
                                style: TextStyle(
                                  fontSize: 38 * fontScale,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  color: isDark
                                      ? AppColors.textHighDark
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                ':$secondStr',
                                style: TextStyle(
                                  fontSize: 38 * fontScale,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  color: const Color(0xFF2C54D8),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'WIB',
                                style: TextStyle(
                                  fontSize: 38 * fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textMediumDark
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jadwal Masuk: 08:00 WIB',
                            style: TextStyle(
                              fontSize: 12 * fontScale,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textMediumDark
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 22),
                          GestureDetector(
                            onTap: handleAttendanceTap,
                            child: Container(
                              width: 196,
                              height: 196,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E2838)
                                    : const Color(0xFFEAF0FA),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black.withValues(alpha: 0.5)
                                        : const Color(
                                            0xFFA6BEDD,
                                          ).withValues(alpha: 0.45),
                                    offset: const Offset(6, 6),
                                    blurRadius: 18,
                                  ),
                                  BoxShadow(
                                    color: isDark
                                        ? const Color(
                                            0xFF26344A,
                                          ).withValues(alpha: 0.6)
                                        : Colors.white.withValues(alpha: 0.95),
                                    offset: const Offset(-6, -6),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: buttonColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: buttonColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        offset: const Offset(0, 6),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mainButtonText,
                                        style: TextStyle(
                                          fontSize: 24 * fontScale,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        subButtonText,
                                        style: TextStyle(
                                          fontSize: 10 * fontScale,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeumorphicCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      borderRadius: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Berhalangan hadir hari ini?',
                                    style: TextStyle(
                                      fontSize: 13 * fontScale,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textHighDark
                                          : AppColors.textHigh,
                                    ),
                                  ),
                                  Text(
                                    'Ajukan surat izin atau keterangan sakit',
                                    style: TextStyle(
                                      fontSize: 11 * fontScale,
                                      color: isDark
                                          ? AppColors.textMediumDark
                                          : AppColors.textMedium,
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
                            child: Text(
                              'Izin',
                              style: TextStyle(
                                fontSize: 13 * fontScale,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: NeumorphicDecorations.extruded(
                        isDark: isDark,
                        borderRadius: 22,
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2C54D8,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.bar_chart_rounded,
                                  size: 20,
                                  color: Color(0xFF2C54D8),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Statistik Kehadiran',
                                style: TextStyle(
                                  fontSize: 16 * fontScale,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.textHighDark
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: NeumorphicDecorations.extrudedSm(
                                    isDark: isDark,
                                    borderRadius: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 3.5,
                                            backgroundColor: Color(0xFF10B981),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Hadir',
                                            style: TextStyle(
                                              fontSize: 12 * fontScale,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF10B981),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${stats.totalMasuk}',
                                        style: TextStyle(
                                          fontSize: 24 * fontScale,
                                          fontWeight: FontWeight.w900,
                                          color: isDark
                                              ? AppColors.textHighDark
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${stats.attendancePercentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: 11 * fontScale,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: NeumorphicDecorations.extrudedSm(
                                    isDark: isDark,
                                    borderRadius: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 3.5,
                                            backgroundColor: Color(0xFFF59E0B),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Izin',
                                            style: TextStyle(
                                              fontSize: 12 * fontScale,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFF59E0B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${stats.totalIzin}',
                                        style: TextStyle(
                                          fontSize: 24 * fontScale,
                                          fontWeight: FontWeight.w900,
                                          color: isDark
                                              ? AppColors.textHighDark
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${stats.totalIzin} Hari',
                                        style: TextStyle(
                                          fontSize: 11 * fontScale,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.textMediumDark
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // card alfa gatau pake apa ngak
                              // const SizedBox(width: 10),
                              // Expanded(
                              //   child: Container(
                              //     decoration: NeumorphicDecorations.extrudedSm(
                              //       isDark: isDark,
                              //       borderRadius: 16,
                              //     ),
                              //     padding: const EdgeInsets.symmetric(
                              //       vertical: 14,
                              //       horizontal: 8,
                              //     ),
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             const CircleAvatar(
                              //               radius: 3.5,
                              //               backgroundColor: Color(0xFFEF4444),
                              //             ),
                              //             const SizedBox(width: 5),
                              //             Text(
                              //               'Alfa',
                              //               style: TextStyle(
                              //                 fontSize: 12 * fontScale,
                              //                 fontWeight: FontWeight.w700,
                              //                 color: const Color(0xFFEF4444),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         const SizedBox(height: 6),
                              //         Text(
                              //           '${stats.totalAlfa}',
                              //           style: TextStyle(
                              //             fontSize: 24 * fontScale,
                              //             fontWeight: FontWeight.w900,
                              //             color: isDark
                              //                 ? AppColors.textHighDark
                              //                 : const Color(0xFF0F172A),
                              //           ),
                              //         ),
                              //         const SizedBox(height: 4),
                              //         Text(
                              //           stats.totalAlfa == 0
                              //               ? 'Nol Absen'
                              //               : '${stats.totalAlfa} Hari',
                              //           style: TextStyle(
                              //             fontSize: 11 * fontScale,
                              //             fontWeight: FontWeight.w700,
                              //             color: stats.totalAlfa == 0
                              //                 ? const Color(0xFF0D9488)
                              //                 : const Color(0xFFEF4444),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
