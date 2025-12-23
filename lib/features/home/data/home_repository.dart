import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class HomeRepository {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  HomeRepository() {
    // 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS/Web
    _dio.options.baseUrl = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api/home'
        : 'http://127.0.0.1:5000/api/home';
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      // 1. Get the User ID we saved during Login
      final userData = _storage.read('user_data');
      if (userData == null) throw Exception("User not found locally");

      int userId = userData['id'];

      // 2. Call the API
      // URL becomes: /dashboard?user_id=1
      final response = await _dio.get(
        '/dashboard',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return response
            .data; // Returns {user_name: "...", eligible_loans: [...]}
      } else {
        throw Exception("Failed to load dashboard");
      }
    } catch (e) {
      throw Exception("Connection Error: ${e.toString()}");
    }
  }
}
