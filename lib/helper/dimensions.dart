import 'package:matrix_ai/data/model/response/api_response.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/material.dart';

class DimensionHelper {
  static Size calculateDimensions(String value, {double? width}) {
    List<String> ratio = value.split(':');
    double aspectWidth = double.parse(ratio[0]);
    double aspectHeight = double.parse(ratio[1]);

    double calculatedWidth = width ?? AppConstants.BASE_WIDTH;
    double calculatedHeight = (calculatedWidth / aspectWidth) * aspectHeight;

    // If calculated height is greater than the allowed maximum, recalculate both width and height
    if (calculatedHeight > AppConstants.MAX_HEIGHT) {
      calculatedHeight = AppConstants.MAX_HEIGHT;
      calculatedWidth = (calculatedHeight / aspectHeight) * aspectWidth;
    }

    // Make sure the width and height are divisible by 8
    calculatedWidth = (calculatedWidth / 8).floor() * 8;
    calculatedHeight = (calculatedHeight / 8).floor() * 8;

    // Ensure we're not exceeding the maximum height after rounding
    if (calculatedHeight > AppConstants.MAX_HEIGHT) {
      calculatedHeight = (AppConstants.MAX_HEIGHT / 8).floor() * 8;
      calculatedWidth = (calculatedHeight / aspectHeight) * aspectWidth;
    }

    return Size(calculatedWidth, calculatedHeight);
  }

  static double getAspectioRatio(String ratio) {
    List<String> ratioList = ratio.split(':');
    return double.parse(ratioList[0]) / double.parse(ratioList[1]);
  }

  static double getAspectRatioFromWidthHeight(PromptResponse response) {
    return response.meta.w / response.meta.h.toDouble();
  }
}
