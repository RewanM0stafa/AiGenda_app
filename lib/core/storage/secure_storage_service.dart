
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // ── Token ──
  Future<void> saveToken(String token) async =>
      await _storage.write(key: StorageKeys.token, value: token);

  Future<String?> getToken() async =>
      await _storage.read(key: StorageKeys.token);

  // ── Refresh Token ──
  Future<void> saveRefreshToken(String token) async =>
      await _storage.write(key: StorageKeys.refreshToken, value: token);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: StorageKeys.refreshToken);

  // ── User ID ──
  Future<void> saveUserId(String userId) async =>
      await _storage.write(key: StorageKeys.userId, value: userId);

  Future<String?> getUserId() async =>
      await _storage.read(key: StorageKeys.userId);

  // ── Email ──
  Future<void> saveEmail(String email) async =>
      await _storage.write(key: StorageKeys.email, value: email);

  Future<String?> getEmail() async =>
      await _storage.read(key: StorageKeys.email);

  // ── Clear All ──
  Future<void> clearAll() async => await _storage.deleteAll();
}