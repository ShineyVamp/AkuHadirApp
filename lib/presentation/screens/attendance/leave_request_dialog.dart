import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absendulu/core/constants/app_colors.dart';
import 'package:absendulu/core/utils/date_formatter.dart';
import 'package:absendulu/presentation/providers/attendance_provider.dart';
import 'package:absendulu/presentation/widgets/custom_snackbar.dart';
import 'package:absendulu/presentation/widgets/neumorphic_button.dart';
import 'package:absendulu/presentation/widgets/neumorphic_text_field.dart';

class LeaveRequestDialog extends StatefulWidget {
  const LeaveRequestDialog({super.key});

  @override
  State<LeaveRequestDialog> createState() => _LeaveRequestDialogState();
}

class _LeaveRequestDialogState extends State<LeaveRequestDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      CustomSnackBar.showError(context, 'Tuliskan alasan izin/sakit Anda');
      return;
    }

    final attendance = Provider.of<AttendanceProvider>(context, listen: false);
    final success = await attendance.submitIzin(reason);

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(context, 'Surat izin berhasil diajukan');
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(
        context,
        attendance.errorMessage ?? 'Gagal mengajukan izin',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendance = Provider.of<AttendanceProvider>(context);

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
                    'Form Pengajuan Izin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textHighDark
                          : AppColors.textHigh,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Tanggal: ${DateFormatter.formatIndonesianDate(DateTime.now())}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                controller: _reasonController,
                labelText: 'Keterangan / Alasan Izin',
                hintText:
                    'Cth. Izin tidak bisa hadir karena sakit demam / urusan keluarga mendesak',
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              NeumorphicButton(
                isPrimary: true,
                color: AppColors.warning,
                isLoading: attendance.isLoading,
                onPressed: _handleSubmit,
                child: const Text(
                  'Kirim Surat Izin',
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
