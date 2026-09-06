import 'dart:convert';
import 'package:AbsenDulu/core/constants/api_endpoints.dart';
import 'package:AbsenDulu/core/network/api_client.dart';
import 'package:AbsenDulu/core/services/storage_service.dart';
import 'package:AbsenDulu/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      withAuth: false,
      body: {'email': email, 'password': password},
    );

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final token = data['token']?.toString();
        if (token != null && token.isNotEmpty) {
          await StorageService.saveToken(token);
        }
        if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
          final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
          await StorageService.saveUserData(jsonEncode(user.toJson()));
          return user;
        }
      }
    }

    throw Exception('Format data respon login tidak sesuai');
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String jenisKelamin,
    required dynamic batchId,
    required dynamic trainingId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      withAuth: false,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'jenis_kelamin': jenisKelamin,
        'batch_id': batchId,
        'training_id': trainingId,
        'profile_photo': '',
      },
    );

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final token = data['token']?.toString();
        if (token != null && token.isNotEmpty) {
          await StorageService.saveToken(token);
        }
        if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
          final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
          await StorageService.saveUserData(jsonEncode(user.toJson()));
          return user;
        }
      }
    }

    throw Exception('Format data respon registrasi tidak sesuai');
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.profile);
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final user = UserModel.fromJson(data);
        await StorageService.saveUserData(jsonEncode(user.toJson()));
        return user;
      }
    }
    throw Exception('Format data respon profil tidak sesuai');
  }

  Future<UserModel> updateProfile(String name) async {
    final response = await _apiClient.put(
      ApiEndpoints.profile,
      body: {'name': name},
    );

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        final user = UserModel.fromJson(data);
        await StorageService.saveUserData(jsonEncode(user.toJson()));
        return user;
      }
    }
    throw Exception('Gagal memperbarui profil');
  }

  Future<String> updateProfilePhoto(String base64Photo) async {
    final response = await _apiClient.put(
      ApiEndpoints.profilePhoto,
      body: {'profile_photo': base64Photo},
    );

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is Map<String, dynamic> && data.containsKey('profile_photo')) {
        return data['profile_photo'].toString();
      }
    }
    return '';
  }

  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiEndpoints.forgotPassword,
      withAuth: false,
      body: {'email': email},
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword,
      withAuth: false,
      body: {'email': email, 'otp': otp, 'password': newPassword},
    );
  }

  Future<void> logout() async {
    await StorageService.clearAll();
  }
}
