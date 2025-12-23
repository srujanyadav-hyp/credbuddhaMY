import 'dart:io';
import 'dart:convert'; // 1. Crucial Import for jsonDecode
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ProfileRepository {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  ProfileRepository() {
    // 10.0.2.2 for Android Emulator, 127.0.0.1 for others
    _dio.options.baseUrl = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api/profile'
        : 'http://127.0.0.1:5000/api/profile';

    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  // --- 1. UPDATE PROFILE (Form Submission) ---
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      // Read data from storage
      var userData = _storage.read('user_data');

      // 2. SAFETY FIX: Decode if it's a String
      if (userData is String) {
        userData = jsonDecode(userData);
      }

      if (userData == null) throw Exception("User not logged in");

      // 3. Add User ID (Now safe to access ['id'])
      data['user_id'] = userData['id'];

      // Send Post Request
      final response = await _dio.post('/update', data: data);
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? "Failed to update profile");
    }
  }

  // --- 2. GET PROFILE (View Screen) ---
  Future<Map<String, dynamic>> getProfile() async {
    try {
      var userData = _storage.read('user_data');

      // 2. SAFETY FIX: Decode here too!
      if (userData is String) {
        userData = jsonDecode(userData);
      }

      if (userData == null) throw Exception("User not logged in");

      int userId = userData['id'];

      // Call API: /get?user_id=1
      final response = await _dio.get(
        '/get',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }
}
