import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akuhadir/core/services/storage_service.dart';import 'package:akuhadir/core/network/api_exception.dart';
class ApiClient {
  final http.Client _client = http.Client();

  Map<String, String> _getHeaders({bool withAuth = true, Map<String, String>? extraHeaders}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (withAuth) {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  dynamic _processResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    String errorMessage = 'Terjadi kesalahan pada server (${response.statusCode})';
    dynamic errors;

    if (body is Map<String, dynamic>) {
      if (body.containsKey('message') && body['message'] != null) {
        errorMessage = body['message'].toString();
      }
      if (body.containsKey('errors')) {
        errors = body['errors'];
        if (errors is Map<String, dynamic>) {
          final firstErrorList = errors.values.firstWhere(
            (v) => v is List && v.isNotEmpty,
            orElse: () => null,
          );
          if (firstErrorList != null && firstErrorList.isNotEmpty) {
            errorMessage = firstErrorList.first.toString();
          }
        }
      }
    }

    throw ApiException(
      message: errorMessage,
      statusCode: response.statusCode,
      errors: errors,
    );
  }

  Future<dynamic> get(String url, {bool withAuth = true, Map<String, String>? headers}) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: _getHeaders(withAuth: withAuth, extraHeaders: headers),
      );
      return _processResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  Future<dynamic> post(
    String url, {
    dynamic body,
    bool withAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: _getHeaders(withAuth: withAuth, extraHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  Future<dynamic> put(
    String url, {
    dynamic body,
    bool withAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: _getHeaders(withAuth: withAuth, extraHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  Future<dynamic> delete(String url, {bool withAuth = true, Map<String, String>? headers}) async {
    try {
      final response = await _client.delete(
        Uri.parse(url),
        headers: _getHeaders(withAuth: withAuth, extraHeaders: headers),
      );
      return _processResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }
}
