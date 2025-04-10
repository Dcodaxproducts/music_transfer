import 'package:flutter/material.dart';
import 'package:get/get.dart';

pop([int times = 1]) {
  for (int i = 0; i < times; i++) {
    Get.back();
  }
}

/// Launch a new screen
Future<dynamic> launchScreen(Widget child, {bool pushAndRemove = false, bool replace = false}) async {
  if (pushAndRemove) {
    return Get.offAll(() => child, routeName: routeName(child));
  } else if (replace) {
    return Get.off(() => child, routeName: routeName(child), preventDuplicates: false);
  } else {
    return Get.to(() => child, routeName: routeName(child), preventDuplicates: false);
  }
}

// Convert widget to route name
String routeName(Widget widget) {
  // Get the class name of the widget as a string
  String className = widget.runtimeType.toString();

  // Remove "Screen" or other suffixes if needed
  if (className.endsWith('Screen')) {
    className = className.replaceAll('Screen', '');
  }

  // Convert to lowercase for route name
  String route = className.toLowerCase();

  return route;
}
