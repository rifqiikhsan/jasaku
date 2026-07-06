class RegisterResponseModel {
  final int status;
  final String message;

  const RegisterResponseModel({required this.status, required this.message});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        status: json['status'] as int,
        message: json['data'] as String,
      );
}
