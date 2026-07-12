import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jasaku/core/services/location_service.dart';
import 'package:jasaku/core/storage/secure_storage.dart';

class LocationState {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? province;
  final bool isLoading;
  final String? errorMessage;

  const LocationState({
    this.latitude,
    this.longitude,
    this.city,
    this.province,
    this.isLoading = false,
    this.errorMessage,
  });

  String get displayText {
    if (city != null && province != null) return '$city, $province';
    return city ?? province ?? '';
  }

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? province,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      province: province ?? this.province,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  final Ref _ref;

  LocationNotifier(this._ref) : super(const LocationState()) {
    _loadCachedLocation();
  }

  Future<void> _loadCachedLocation() async {
    final storage = _ref.read(secureStorageProvider);
    final cachedCoord = await storage.getLastLocation();
    final cachedAddress = await storage.getLastAddress();

    state = state.copyWith(
      latitude: cachedCoord?.lat,
      longitude: cachedCoord?.lng,
      city: cachedAddress.city,
      province: cachedAddress.province,
    );
  }

  Future<void> requestAndFetchLocation() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final locationService = _ref.read(locationServiceProvider);
    final result = await locationService.requestPermission();

    switch (result) {
      case LocationPermissionResult.granted:
        try {
          final position = await locationService.getCurrentPosition();
          final address = await locationService.getAddressFromCoordinates(
            position.latitude,
            position.longitude,
          );

          final storage = _ref.read(secureStorageProvider);
          await storage.saveLastLocation(position.latitude, position.longitude);
          await storage.saveLastAddress(address.city, address.province);

          state = state.copyWith(
            latitude: position.latitude,
            longitude: position.longitude,
            city: address.city,
            province: address.province,
            isLoading: false,
          );
        } catch (e) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Gagal mengambil lokasi.',
          );
        }
        break;

      case LocationPermissionResult.denied:
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Izin lokasi ditolak.',
        );
        break;

      case LocationPermissionResult.deniedForever:
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Izin lokasi ditolak permanen. Aktifkan lewat pengaturan aplikasi.',
        );
        break;

      case LocationPermissionResult.serviceDisabled:
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Layanan lokasi (GPS) tidak aktif.',
        );
        break;
    }
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(ref),
);
