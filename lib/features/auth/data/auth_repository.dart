import 'package:dio/dio.dart';
import 'dart:io';

class AuthRepository {
  final Dio _dio = Dio();
  AuthRepository() {
    _dio.options.baseUrl = _getBaseUrl();
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      "Content-Type": 'application/json',
      'Accept': 'application/json',
    };
  }
  String _getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api/auth';
    } else {
      return 'http://127.0.0.1:5000/api/auth';
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    try {
      print("🚀 Connecting to: ${_dio.options.baseUrl}/send-otp");

      // 3. THE REQUEST (Cleaner syntax than http)
      // No need for jsonEncode(), Dio handles it automatically.
      final response = await _dio.post(
        '/send-otp',
        data: {'phone': phoneNumber},
      );

      print("✅ Response: ${response.data}");

      // Dio considers 200-299 as success automatically.
      return true;
    } on DioException catch (e) {
      // 4. PRECISE ERROR HANDLING
      // Dio gives us detailed info about WHAT went wrong.

      if (e.response != null) {
        // Server reached, but it returned an error (400, 401, 500)
        print("❌ Server Error: ${e.response?.data}");

        // Extract the error message from Flask: {"error": "Invalid phone"}
        String errorMessage = e.response?.data['error'] ?? "Server Error";
        throw Exception(errorMessage);
      } else {
        // Server NOT reached (No Internet, Timeout, Server Down)
        print("❌ Network Error: ${e.message}");
        throw Exception("Connection failed. Check your internet.");
      }
    }
  }

  // ... inside AuthRepository class ...

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );

      // Success! Return the data (Token + User Info)
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        String errorMessage =
            e.response?.data['error'] ?? "Verification Failed";
        throw Exception(errorMessage);
      } else {
        throw Exception("Connection failed. Check your internet.");
      }
    }
  }
}
