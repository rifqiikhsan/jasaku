import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LocationPermissionResult {
  granted,
  deniedForever,
  denied,
  serviceDisabled,
}

class AddressInfo {
  final String? city;
  final String? province;

  const AddressInfo({this.city, this.province});

  String get displayText {
    if (city != null && province != null) return '$city, $province';
    return city ?? province ?? 'Lokasi tidak diketahui';
  }
}

class LocationService {
  final Geocoding _geocoding = Geocoding();

  Future<LocationPermissionResult> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionResult.serviceDisabled;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.deniedForever;
    }

    return LocationPermissionResult.granted;
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // ── Reverse Geocoding ────────────────────────────────────
  Future<AddressInfo> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return const AddressInfo();

      final place = placemarks.first;

      final city = place.locality?.isNotEmpty == true
          ? place.locality
          : place.subAdministrativeArea;

      final province = place.administrativeArea;

      return AddressInfo(city: city, province: province);
    } catch (e) {
      return const AddressInfo();
    }
  }
}

final locationServiceProvider = Provider<LocationService>(
  (_) => LocationService(),
);
