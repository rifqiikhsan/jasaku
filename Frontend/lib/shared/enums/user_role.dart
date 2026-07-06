enum UserRole {
  pencariJasa,
  penyediaJasa;

  String toApiString() => switch (this) {
    UserRole.pencariJasa => 'CUSTOMER',
    UserRole.penyediaJasa => 'PROVIDER',
  };

  static UserRole fromApiString(String value) => switch (value) {
    'CUSTOMER' => UserRole.pencariJasa,
    'PROVIDER' => UserRole.penyediaJasa,
    _ => UserRole.pencariJasa,
  };
}
