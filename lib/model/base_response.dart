class BaseResponse {

  BaseResponse();

  BaseResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status'];
    message = json['message'] ?? message;
  }
  int statusCode;
  String message;
}