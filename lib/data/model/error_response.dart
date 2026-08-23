class ErrorResponse {
  final String? status;
  final int? statusCode;
  final String? message;
  final bool? success;

  ErrorResponse({this.status, this.statusCode, this.message, this.success});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    success: json["success"],
  );
}