import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ProfileRepository {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  ProfileRepository() {
    _dio.options.baseUrl = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api/profile'
        : 'http://127.0.0.1:5000/api/profile';

    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      // 1. Get the User ID from local storage (Saved during Login)
      final userData = _storage.read('user_data');
      if (userData == null) throw Exception("User not logged in");

      // 2. Add User ID to the data payload
      data['user_id'] = userData['id'];

      // 3. Send Request
      final response = await _dio.post('/update', data: data);

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? "Failed to update profile");
    }
  }
}
