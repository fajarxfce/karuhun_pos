import 'package:injectable/injectable.dart';
import 'package:karuhun_pos/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:karuhun_pos/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/exceptions.dart' as core_exceptions;

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      await sharedPreferences.setString(_userKey, userJson.toString());
    } catch (e) {
      throw core_exceptions.CacheException('Failed to save user data');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userString = sharedPreferences.getString(_userKey);
      if (userString != null) {
        return null;
      }
      return null;
    } catch (e) {
      throw core_exceptions.CacheException('Failed to get user data');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(_userKey);
    } catch (e) {
      throw core_exceptions.CacheException('Failed to clear user data');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      throw core_exceptions.CacheException('Failed to get token');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await sharedPreferences.setString(_tokenKey, token);
    } catch (e) {
      throw core_exceptions.CacheException('Failed to save token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(_tokenKey);
    } catch (e) {
      throw core_exceptions.CacheException('Failed to clear token');
    }
  }
}
