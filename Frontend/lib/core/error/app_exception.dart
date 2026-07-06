class AppException implements Exception {
  final String message;
  final int? status;

  const AppException({required this.message, this.status});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Tidak ada koneksi internet',
    super.status,
  });
}

class ServerException extends AppException {
  const ServerException({required super.message, super.status});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Sesi habis, silakan login kembali',
    super.status = 401,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Data tidak ditemukan',
    super.status = 404,
  });
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Data tidak valid',
    super.status = 422,
    this.errors,
  });
}

class CacheException extends AppException {
  const CacheException({super.message = 'Gagal membaca data lokal'});
}
