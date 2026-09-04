import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:akuhadir/core/constants/app_colors.dart';
import 'package:akuhadir/core/services/location_service.dart';
import 'package:akuhadir/presentation/providers/attendance_provider.dart';
import 'package:akuhadir/presentation/widgets/custom_snackbar.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_button.dart';
import 'package:akuhadir/presentation/widgets/neumorphic_card.dart';

class GpsVerificationScreen extends StatefulWidget {
  final bool isCheckIn;

  const GpsVerificationScreen({
    super.key,
    required this.isCheckIn,
  });

  @override
  State<GpsVerificationScreen> createState() => _GpsVerificationScreenState();
}

class _GpsVerificationScreenState extends State<GpsVerificationScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).updateLocation();
    });
  }

  Future<void> _handleConfirmAttendance() async {
    final attendance = Provider.of<AttendanceProvider>(context, listen: false);

    bool success;
    if (widget.isCheckIn) {
      success = await attendance.checkIn();
    } else {
      success = await attendance.checkOut();
    }

    if (!mounted) return;

    if (success) {
      CustomSnackBar.showSuccess(
        context,
        widget.isCheckIn ? 'Absen Masuk Berhasil!' : 'Absen Pulang Berhasil!',
      );
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(
        context,
        attendance.errorMessage ?? 'Gagal memproses presensi',
      );
    }
  }

  Future<void> _openExternalGoogleMaps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        CustomSnackBar.showError(context, 'Tidak dapat membuka aplikasi Google Maps');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final attendance = Provider.of<AttendanceProvider>(context);

    final currentPos = attendance.currentPosition;
    final lat = currentPos?.latitude ?? LocationService.ppkdLat;
    final lng = currentPos?.longitude ?? LocationService.ppkdLng;
    final userLatLng = LatLng(lat, lng);
    final ppkdLatLng = const LatLng(LocationService.ppkdLat, LocationService.ppkdLng);
    final isSafe = attendance.isInsideGeofence;
    final distanceMeters = attendance.distanceToPpkd.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCheckIn ? 'Verifikasi Lokasi Masuk' : 'Verifikasi Lokasi Pulang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NeumorphicCard(
                padding: EdgeInsets.zero,
                borderRadius: 20,
                child: SizedBox(
                  height: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: userLatLng,
                            initialZoom: 17.5,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.ppkd.akuhadir',
                            ),
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: ppkdLatLng,
                                  radius: LocationService.geofenceRadius,
                                  useRadiusInMeter: true,
                                  color: AppColors.success.withValues(alpha: 0.2),
                                  borderColor: AppColors.success,
                                  borderStrokeWidth: 2,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: ppkdLatLng,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.business_rounded,
                                    color: AppColors.primary,
                                    size: 36,
                                  ),
                                ),
                                Marker(
                                  point: userLatLng,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.person_pin_circle_rounded,
                                    color: AppColors.danger,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardBgDark.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.radar_rounded, size: 16, color: AppColors.primary),
                                SizedBox(width: 6),
                                Text(
                                  'Radius Presensi 50m',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: InkWell(
                            onTap: () => _openExternalGoogleMaps(lat, lng),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardBgDark : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4),
                                ],
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.map_rounded, size: 14, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Peta Google',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              NeumorphicCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSafe ? AppColors.successLight : AppColors.dangerLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSafe ? Icons.check_circle_rounded : Icons.warning_rounded,
                        color: isSafe ? AppColors.success : AppColors.danger,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSafe ? 'Dalam Radius Aman PPKD' : 'Di Luar Radius Presensi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSafe ? AppColors.success : AppColors.danger,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isSafe
                                ? 'Jarak aktual: $distanceMeters meter dari gerbang PPKD'
                                : 'Jarak aktual: $distanceMeters meter (Maksimal 50m)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              NeumorphicCard(
                borderRadius: 16,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Koordinat GPS',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                          ),
                        ),
                        Text(
                          '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status Geolocation',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Akurat (Satelit Aktif)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lokasi Terdeteksi',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textMediumDark : AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            LocationService.ppkdAddress,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textHighDark : AppColors.textHigh,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              NeumorphicButton(
                isPrimary: true,
                color: widget.isCheckIn ? AppColors.primary : AppColors.success,
                isLoading: attendance.isLoading,
                onPressed: _handleConfirmAttendance,
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isCheckIn ? Icons.login_rounded : Icons.logout_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isCheckIn
                          ? 'Konfirmasi Absen Masuk'
                          : 'Konfirmasi Absen Pulang',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              NeumorphicButton(
                onPressed: () => attendance.updateLocation(),
                height: 48,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Kalibrasi Ulang GPS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
