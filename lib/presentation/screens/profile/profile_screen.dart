import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akuhadir/core/constants/app_colors.dart';
import 'package:akuhadir/core/theme/neumorphic_decorations.dart';
import 'package:akuhadir/presentation/screens/auth/login_screen.dart';
import 'package:akuhadir/presentation/providers/auth_provider.dart';
import 'package:akuhadir/presentation/providers/theme_provider.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_button.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_card.dart';
import 'package:akuhadir/presentation/screens/profile/edit_profile_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: NeumorphicDecorations.extruded(
                        isDark: isDark,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: user?.profilePhoto != null && user!.profilePhoto!.isNotEmpty
                            ? Image.network(
                                user.profilePhoto!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.person_rounded,
                                  size: 54,
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 54,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const EditProfileDialog(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Nama Siswa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'nama@siswa.ppkd.id',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Data Pribadi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                ),
              ),
              const SizedBox(height: 12),
              NeumorphicCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(
                              'Nama Lengkap',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              user?.name ?? '-',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const EditProfileDialog(),
                                );
                              },
                              child: const Icon(Icons.edit_note_rounded, size: 18, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(
                              'Email Akun',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          user?.email ?? '-',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wc_rounded, size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(
                              'Jenis Kelamin',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          user?.jenisKelamin == 'P' ? 'Perempuan' : 'Laki-laki',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pengaturan Sistem',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                ),
              ),
              const SizedBox(height: 12),
              NeumorphicCard(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              theme.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Mode Tampilan Gelap',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: theme.isDarkMode,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) => theme.toggleTheme(val),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified_user_outlined, size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Text(
                                'Versi Aplikasi',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'AkuHadir v1.0.0 (PPKD)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              NeumorphicButton(
                isPrimary: true,
                color: AppColors.danger,
                height: 50,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dCtx) => AlertDialog(
                      title: const Text('Keluar dari Akun?'),
                      content: const Text(
                        'Anda perlu masuk kembali dengan email dan password untuk mengakses aplikasi.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dCtx, false),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                          onPressed: () => Navigator.pop(dCtx, true),
                          child: const Text('Keluar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await auth.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Keluar Akun',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
