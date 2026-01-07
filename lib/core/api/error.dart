class ErrorResponse {
  final List<Error> errors;

  ErrorResponse({required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      errors: json['error'] != null
          ? [ErrorResponse.handleError(json)]
          : List<Error>.from(json['errors'].map((x) => Error.fromJson(x))),
    );
  }

  static Error handleError(Map<String, dynamic> json) {
    if (json['error'] is String) {
      return Error.fromJson({'message': json['error']});
    } else {
      return Error.fromJson(json['error']);
    }
  }
}

class Error {
  final String message;
  Error({required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message']);
  }
}
