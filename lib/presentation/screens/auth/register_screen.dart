import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absendulu/core/constants/app_colors.dart';
import 'package:absendulu/core/theme/neumorphic_decorations.dart';
import 'package:absendulu/data/models/batch_model.dart';
import 'package:absendulu/data/models/training_model.dart';
import 'package:absendulu/data/repositories/master_repository.dart';
import 'package:absendulu/extensions/navigation.dart';
import 'package:absendulu/presentation/screens/main/main_screen.dart';
import 'package:absendulu/presentation/providers/auth_provider.dart';
import 'package:absendulu/presentation/widgets/custom_snackbar.dart';
import 'package:absendulu/presentation/widgets/neumorphic_button.dart';
import 'package:absendulu/presentation/widgets/neumorphic_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final MasterRepository _masterRepo = MasterRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _gender = 'L';
  BatchModel? _selectedBatch;
  TrainingModel? _selectedTraining;

  List<BatchModel> _batches = [];
  List<TrainingModel> _trainings = [];
  bool _isLoadingMaster = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  @override
  void initState() {
    super.initState();
    _loadMasterData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadMasterData() async {
    try {
      final batches = await _masterRepo.getBatches();
      final trainings = await _masterRepo.getTrainings();
      if (mounted) {
        setState(() {
          _batches = batches;
          _trainings = trainings;
          if (_batches.isNotEmpty) {
            _selectedBatch = _batches.first;
            if (_selectedBatch?.trainings != null &&
                _selectedBatch!.trainings!.isNotEmpty) {
              _selectedTraining = _selectedBatch!.trainings!.first;
            }
          }
          if (_selectedTraining == null && _trainings.isNotEmpty) {
            _selectedTraining = _trainings.first;
          }
          _isLoadingMaster = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingMaster = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      CustomSnackBar.showError(
        context,
        'Setujui syarat dan ketentuan untuk mendaftar',
      );
      return;
    }

    if (_selectedBatch == null || _selectedTraining == null) {
      CustomSnackBar.showError(context, 'Pilih batch dan kejuruan pelatihan');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      jenisKelamin: _gender,
      batchId: _selectedBatch!.id,
      trainingId: _selectedTraining!.id,
    );

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        'Registrasi berhasil! Selamat datang',
      );
      context.pushAndRemoveAll(const MainScreen());
    } else {
      CustomSnackBar.showError(
        context,
        auth.errorMessage ?? 'Gagal melakukan registrasi',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Peserta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _isLoadingMaster
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Lengkapi Identitas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textHighDark
                              : AppColors.textHigh,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftarkan diri Anda sebagai siswa pelatihan resmi PPKD',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMediumDark
                              : AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      NeumorphicTextField(
                        controller: _nameController,
                        labelText: 'Nama Lengkap Siswa',
                        hintText: 'cth. Ahmad Fauzi',
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Nama lengkap wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      NeumorphicTextField(
                        controller: _emailController,
                        labelText: 'Email Resmi Siswa',
                        hintText: 'nama@siswa.ppkd.id',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!val.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Jenis Kelamin',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textMediumDark
                              : AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _gender = 'L'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: _gender == 'L'
                                    ? NeumorphicDecorations.primaryPill(
                                        color: AppColors.primary,
                                        borderRadius: 14,
                                      )
                                    : NeumorphicDecorations.insetWell(
                                        isDark: isDark,
                                        borderRadius: 14,
                                      ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Laki-laki',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _gender == 'L'
                                        ? Colors.white
                                        : (isDark
                                              ? AppColors.textHighDark
                                              : AppColors.textHigh),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _gender = 'P'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: _gender == 'P'
                                    ? NeumorphicDecorations.primaryPill(
                                        color: AppColors.primary,
                                        borderRadius: 14,
                                      )
                                    : NeumorphicDecorations.insetWell(
                                        isDark: isDark,
                                        borderRadius: 14,
                                      ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Perempuan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _gender == 'P'
                                        ? Colors.white
                                        : (isDark
                                              ? AppColors.textHighDark
                                              : AppColors.textHigh),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Batch Pelatihan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textMediumDark
                              : AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: NeumorphicDecorations.insetWell(
                          isDark: isDark,
                          borderRadius: 14,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<BatchModel>(
                            isExpanded: true,
                            value: _selectedBatch,
                            dropdownColor: isDark
                                ? AppColors.cardBgDark
                                : AppColors.cardBg,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                            ),
                            items: _batches.map((b) {
                              return DropdownMenuItem<BatchModel>(
                                value: b,
                                child: Text(
                                  '${b.displayName} (${b.startDate ?? ''})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textHighDark
                                        : AppColors.textHigh,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedBatch = val;
                                if (val?.trainings != null &&
                                    val!.trainings!.isNotEmpty) {
                                  _selectedTraining = val.trainings!.first;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kejuruan Pelatihan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textMediumDark
                              : AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: NeumorphicDecorations.insetWell(
                          isDark: isDark,
                          borderRadius: 14,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TrainingModel>(
                            isExpanded: true,
                            value: _selectedTraining,
                            dropdownColor: isDark
                                ? AppColors.cardBgDark
                                : AppColors.cardBg,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                            ),
                            items:
                                (_selectedBatch?.trainings != null &&
                                            _selectedBatch!
                                                .trainings!
                                                .isNotEmpty
                                        ? _selectedBatch!.trainings!
                                        : _trainings)
                                    .map((t) {
                                      return DropdownMenuItem<TrainingModel>(
                                        value: t,
                                        child: Text(
                                          t.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? AppColors.textHighDark
                                                : AppColors.textHigh,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedTraining = val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      NeumorphicTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Minimal 8 karakter',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: isDark
                                ? AppColors.textLowDark
                                : AppColors.textLow,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.length < 8) {
                            return 'Password minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      NeumorphicTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Konfirmasi Password',
                        hintText: 'Ulangi password',
                        obscureText: _obscureConfirm,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: isDark
                                ? AppColors.textLowDark
                                : AppColors.textLow,
                          ),
                        ),
                        validator: (val) {
                          if (val != _passwordController.text) {
                            return 'Konfirmasi password tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) =>
                                setState(() => _agreeTerms = val ?? false),
                          ),
                          Expanded(
                            child: Text(
                              'Saya menyetujui seluruh ketentuan dan tata tertib presensi PPKD Jakarta',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMediumDark
                                    : AppColors.textMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      NeumorphicButton(
                        isPrimary: true,
                        isLoading: auth.isLoading,
                        onPressed: _handleRegister,
                        height: 52,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
