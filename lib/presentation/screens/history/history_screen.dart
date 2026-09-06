import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absendulu/core/constants/app_colors.dart';
import 'package:absendulu/core/utils/date_formatter.dart';
import 'package:absendulu/presentation/providers/history_provider.dart';
import 'package:absendulu/presentation/widgets/neumorphic_card.dart';
import 'package:absendulu/presentation/widgets/neumorphic_status_chip.dart';
import 'package:absendulu/presentation/screens/history/history_detail_sheet.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final history = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Presensi'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicCard(
                    isSmall: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    onTap: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: history.currentMonth,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      );
                      if (selected != null) {
                        history.changeMonth(selected);
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormatter.formatMonthYear(history.currentMonth),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textHighDark
                                : AppColors.textHigh,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${history.historyList.length} Catatan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textMediumDark
                          : AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: history.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : history.historyList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 56,
                            color: isDark
                                ? AppColors.textLowDark
                                : AppColors.textLow,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada catatan presensi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textMediumDark
                                  : AppColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Data absensi bulan ini akan tampil di sini',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textLowDark
                                  : AppColors.textLow,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => history.loadHistory(),
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                        itemCount: history.historyList.length,
                        itemBuilder: (context, index) {
                          final item = history.historyList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: NeumorphicCard(
                              borderRadius: 16,
                              padding: const EdgeInsets.all(16),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) =>
                                      HistoryDetailSheet(attendance: item),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.attendanceDate ?? 'Presensi',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.textHighDark
                                              : AppColors.textHigh,
                                        ),
                                      ),
                                      NeumorphicStatusChip(
                                        status: item.effectiveStatus,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.login_rounded,
                                              size: 14,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Masuk: ${item.effectiveCheckInTime}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? AppColors.textHighDark
                                                    : AppColors.textHigh,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.logout_rounded,
                                              size: 14,
                                              color: AppColors.success,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Pulang: ${item.effectiveCheckOutTime}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? AppColors.textHighDark
                                                    : AppColors.textHigh,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item.effectiveCoordinates != null &&
                                      item
                                          .effectiveCoordinates!
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.my_location_rounded,
                                          size: 13,
                                          color: AppColors.textMedium,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item.effectiveCoordinates!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark
                                                  ? AppColors.textMediumDark
                                                  : AppColors.textMedium,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
