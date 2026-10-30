import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/society_role_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<String?> getAccessToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveActiveRole(SocietyRoleModel role);
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await storageService.write(ApiConstants.accessTokenKey, accessToken);
      await storageService.write(ApiConstants.refreshTokenKey, refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to securely store authentication tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await storageService.read(ApiConstants.accessTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve access token');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonStr = jsonEncode(user.toJson());
      await storageService.write(ApiConstants.activeUserKey, jsonStr);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user session');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final jsonStr = await storageService.read(ApiConstants.activeUserKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveActiveRole(SocietyRoleModel role) async {
    try {
      final jsonStr = jsonEncode(role.toJson());
      await storageService.write(ApiConstants.activeRoleKey, jsonStr);
    } catch (e) {
      throw CacheException(message: 'Failed to save active role');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await storageService.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear session data');
    }
  }
}
