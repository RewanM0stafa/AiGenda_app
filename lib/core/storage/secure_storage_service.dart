import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  // ─────────── TOKENS ───────────

  Future<void> saveAccessToken(String token) async =>
      await _storage.write(key: StorageKeys.token, value: token);

  Future<String?> getAccessToken() async =>
      await _storage.read(key: StorageKeys.token);

  Future<void> deleteAccessToken() async =>
      await _storage.delete(key: StorageKeys.token);

  Future<void> saveRefreshToken(String token) async =>
      await _storage.write(key: StorageKeys.refreshToken, value: token);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: StorageKeys.refreshToken);

  Future<void> deleteRefreshToken() async =>
      await _storage.delete(key: StorageKeys.refreshToken);

  // ─────────── USER DATA ───────────

  Future<void> saveUserId(String userId) async =>
      await _storage.write(key: StorageKeys.userId, value: userId);

  Future<String?> getUserId() async =>
      await _storage.read(key: StorageKeys.userId);

  Future<void> deleteUserId() async =>
      await _storage.delete(key: StorageKeys.userId);

  Future<void> saveEmail(String email) async =>
      await _storage.write(key: StorageKeys.email, value: email);

  Future<String?> getEmail() async =>
      await _storage.read(key: StorageKeys.email);

  Future<void> deleteEmail() async =>
      await _storage.delete(key: StorageKeys.email);

  Future<void> saveFirstName(String? name) async {
    if (name == null) {
      await _storage.delete(key: StorageKeys.firstName);
    } else {
      await _storage.write(key: StorageKeys.firstName, value: name);
    }
  }

  Future<String?> getFirstName() async =>
      await _storage.read(key: StorageKeys.firstName);

  Future<void> saveLastName(String? name) async {
    if (name == null) {
      await _storage.delete(key: StorageKeys.lastName);
    } else {
      await _storage.write(key: StorageKeys.lastName, value: name);
    }
  }

  Future<String?> getLastName() async =>
      await _storage.read(key: StorageKeys.lastName);

  // ─────────── AVATAR ───────────

  Future<void> saveAvatar(String url) async =>
      await _storage.write(key: StorageKeys.avatar, value: url);

  Future<String?> getAvatar() async =>
      await _storage.read(key: StorageKeys.avatar);

  Future<void> deleteAvatar() async =>
      await _storage.delete(key: StorageKeys.avatar);

  // ─────────── COMBINED ───────────

  Future<void> saveUserData({
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    await saveUserId(userId);
    await saveEmail(email);
    await saveFirstName(firstName);
    await saveLastName(lastName);
  }

  // ─────────── CLEAR ───────────

  Future<void> clearAll() async => await _storage.deleteAll();
}