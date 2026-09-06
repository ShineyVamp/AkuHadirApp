import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:absendulu/core/constants/app_colors.dart';
import 'package:absendulu/core/utils/image_helper.dart';
import 'package:absendulu/extensions/navigation.dart';
import 'package:absendulu/presentation/providers/auth_provider.dart';
import 'package:absendulu/presentation/widgets/custom_snackbar.dart';
import 'package:absendulu/presentation/widgets/neumorphic_button.dart';
import 'package:absendulu/presentation/widgets/neumorphic_text_field.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      CustomSnackBar.showError(context, 'Nama lengkap tidak boleh kosong');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updateProfile(name);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(context, 'Profil berhasil diperbarui');
      context.pop();
    } else {
      CustomSnackBar.showError(
        context,
        auth.errorMessage ?? 'Gagal memperbarui profil',
      );
    }
  }

  Future<void> _handlePickPhoto() async {
    final base64Image = await ImageHelper.pickImageAsBase64(
      source: ImageSource.gallery,
    );
    if (base64Image != null && mounted) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final success = await auth.updateProfilePhoto(base64Image);
      if (mounted) {
        if (success) {
          CustomSnackBar.showSuccess(
            context,
            'Foto profil berhasil diperbarui',
          );
        } else {
          CustomSnackBar.showError(
            context,
            auth.errorMessage ?? 'Gagal memperbarui foto',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);

    return Dialog(
      backgroundColor: isDark ? AppColors.cardBgDark : AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ubah Profil Siswa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textHighDark
                          : AppColors.textHigh,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NeumorphicButton(
                onPressed: _handlePickPhoto,
                height: 44,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ganti Foto Profil',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                hintText: 'Nama lengkap Anda',
                prefixIcon: const Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              NeumorphicButton(
                isPrimary: true,
                isLoading: auth.isLoading,
                onPressed: _handleSave,
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
