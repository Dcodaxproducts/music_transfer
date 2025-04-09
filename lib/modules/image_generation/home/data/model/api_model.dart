class ApiKeyModel {
  final bool delay;
  final String apiKey;
  final int? timeRemaining;
  final String? lastCall;

  ApiKeyModel({
    required this.delay,
    required this.apiKey,
    required this.timeRemaining,
    this.lastCall,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) {
    return ApiKeyModel(
      delay: json['delay'],
      apiKey: json['api_key'],
      timeRemaining: json['time_remaining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delay': delay,
      'api_key': apiKey,
      'time_remaining': timeRemaining,
      'last_call': lastCall,
    };
  }
}
