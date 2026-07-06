abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

class ServerFailure extends Failure {
  final int? status;
  const ServerFailure(super.message, {this.status});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Sesi habis, silakan login kembali',
  ]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Data tidak ditemukan']);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  const ValidationFailure(super.message, {this.errors});
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal membaca data lokal']);
}
