import 'dart:io';
import 'dart:convert'; // 1. IMPORT THIS
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class HomeRepository {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  HomeRepository() {
    _dio.options.baseUrl = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api/home'
        : 'http://127.0.0.1:5000/api/home';
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      // 1. Get the User ID
      var userData = _storage.read('user_data');

      // 2. THE FIX: Decode if it is a String
      if (userData is String) {
        userData = jsonDecode(userData);
      }

      if (userData == null) throw Exception("User not found locally");

      int userId = userData['id']; // Now this works!

      // 3. Call the API
      final response = await _dio.get(
        '/dashboard',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load dashboard");
      }
    } catch (e) {
      throw Exception("Connection Error: ${e.toString()}");
    }
  }
}
