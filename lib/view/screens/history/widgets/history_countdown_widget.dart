import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/prompt_details/prompt_details.dart';

class HistoryCountdownWidget extends StatefulWidget {
  final PromptResponse response;
  final Widget Function(BuildContext context, bool isCompleted, String imageUrl,
      String remainingTime) builder;

  const HistoryCountdownWidget({
    super.key,
    required this.response,
    required this.builder,
  });

  @override
  State<HistoryCountdownWidget> createState() => _HistoryCountdownWidgetState();
}

class _HistoryCountdownWidgetState extends State<HistoryCountdownWidget> {
  Timer? countdownTimer;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();

    // Initialize remaining time based on PromptResponse
    int initialSeconds = (((widget.response.eta ?? 0) + 5) * 2).ceil();
    DateTime etaWithBuffer =
        widget.response.createdAt!.add(Duration(seconds: initialSeconds));
    remainingTime = etaWithBuffer.difference(DateTime.now());
    if (widget.response.status != 'success') {
      startCountdown();
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        remainingTime -= const Duration(seconds: 1);
      });

      // When time reaches 0, call the API
      if (remainingTime.isNegative || remainingTime == Duration.zero) {
        countdownTimer?.cancel();
        await _checkImageStatus();
      }
    });
  }

  Future<void> _checkImageStatus() async {
    bool success =
        await ImageGenerationController.find.getQueuedImages(widget.response);

    if (success) {
      setState(() {
        remainingTime = Duration.zero;
        countdownTimer?.cancel(); // Stop timer on success
      });
    } else {
      // If API fails, reset countdown to 30 seconds and restart
      setState(() {
        remainingTime = Duration(seconds: inititialSeconds);
      });
      startCountdown(); // Restart countdown
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted =
        widget.response.status == 'success' || remainingTime == Duration.zero;
    final imageUrl = widget.response.output.isNotEmpty
        ? widget.response.output[0]
        : widget.response.futureLinks.first;

    return InkWell(
      onTap: () {
        if (!isCompleted) return;
        launchScreen(PromptDetailScreen(response: widget.response));
      },
      borderRadius: BorderRadius.circular(radius),
      child: widget.builder(
        context,
        isCompleted,
        imageUrl,
        _formatDuration(remainingTime),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "00:00";
    }

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  int get inititialSeconds {
    int initialSecs = (((widget.response.eta ?? 0) + 5) * 2).ceil();
    return initialSecs;
  }
}
