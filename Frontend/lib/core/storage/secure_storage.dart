import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Keys ────────────────────────────────────────────────
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyUserRole = 'user_role';
  static const _keyFullName = 'full_name';
  static const _keyLatitude = 'last_latitude';
  static const _keyLongitude = 'last_longitude';
  static const _keyCity = 'last_city';
  static const _keyProvince = 'last_province';

  // ── Access Token ─────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  // ── Refresh Token ────────────────────────────────────────
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  // ── User info ────────────────────────────────────────────
  Future<void> saveUserId(String id) =>
      _storage.write(key: _keyUserId, value: id);

  Future<String?> getUserId() => _storage.read(key: _keyUserId);

  Future<void> saveUserRole(String role) =>
      _storage.write(key: _keyUserRole, value: role);

  Future<String?> getUserRole() => _storage.read(key: _keyUserRole);

  Future<void> saveFullName(String name) =>
      _storage.write(key: _keyFullName, value: name);

  Future<String?> getFullName() => _storage.read(key: _keyFullName);

  // ── Location (koordinat) ───────────────────────────────────
  Future<void> saveLastLocation(double lat, double lng) async {
    await _storage.write(key: _keyLatitude, value: lat.toString());
    await _storage.write(key: _keyLongitude, value: lng.toString());
  }

  Future<({double lat, double lng})?> getLastLocation() async {
    final latStr = await _storage.read(key: _keyLatitude);
    final lngStr = await _storage.read(key: _keyLongitude);
    if (latStr == null || lngStr == null) return null;
    return (lat: double.parse(latStr), lng: double.parse(lngStr));
  }

  // ── Location (alamat: kota & provinsi) ──────────────────────
  Future<void> saveLastAddress(String? city, String? province) async {
    if (city != null) await _storage.write(key: _keyCity, value: city);
    if (province != null) {
      await _storage.write(key: _keyProvince, value: province);
    }
  }

  Future<({String? city, String? province})> getLastAddress() async {
    final city = await _storage.read(key: _keyCity);
    final province = await _storage.read(key: _keyProvince);
    return (city: city, province: province);
  }

  // ── Clear ────────────────────────────────────────────────
  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  Future<void> clearAll() => _storage.deleteAll();

  // ── Helpers ──────────────────────────────────────────────
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

final secureStorageProvider = Provider<SecureStorage>((_) => SecureStorage._());
