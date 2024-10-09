// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationHelper {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.getInitialMessage().then((message) {});
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // android
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS
    var iOSInitialize = const DarwinInitializationSettings();

    // initialization settings
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    // initialize
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message, flutterLocalNotificationsPlugin, kIsWeb);
    });
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    String? title;
    String? body;
    String? orderID;
    String? image;
    String? type = '';

    if (data) {
      title = message.data['title'];
      body = message.data['body'];
      orderID = message.data['order_id'];
    } else {
      title = message.notification!.title;
      body = message.notification!.body;
      orderID = message.notification!.titleLocKey;
    }

    if (message.data['type'] != null) {
      type = message.data['type'];
    }

    Map<String, String> payloadData = {
      'title': '$title',
      'body': '$body',
      'order_id': '$orderID',
      'image': '$image',
      'type': '$type',
    };

    PayloadModel payload = PayloadModel.fromJson(payloadData);

    await showBigTextNotification(payload, fln);
  }

  static Future<void> showBigTextNotification(
      PayloadModel payload, FlutterLocalNotificationsPlugin fln) async {
    final bigTextStyleInformation = BigTextStyleInformation(
      payload.body!,
      htmlFormatBigText: true,
      contentTitle: payload.title,
      htmlFormatContentTitle: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.APP_NAME,
      AppConstants.APP_NAME,
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('notification'),
    );

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await fln.show(
      0,
      payload.title,
      payload.body,
      platformChannelSpecifics,
      payload: jsonEncode(payload.toJson()),
    );
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      PayloadModel payload, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath =
        await _downloadAndSaveFile(payload.image!, 'largeIcon');

    final String bigPicturePath =
        await _downloadAndSaveFile(payload.image!, 'bigPicture');

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: payload.title,
      htmlFormatContentTitle: true,
      summaryText: payload.body,
      htmlFormatSummaryText: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      AppConstants.APP_NAME,
      AppConstants.APP_NAME,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      // sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await fln.show(0, payload.title, payload.body, platformChannelSpecifics,
        payload: jsonEncode(payload.toJson()));
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<dynamic> myBackgroundMessageHandler(
      RemoteMessage message) async {
    debugPrint(
        "onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}");
  }
}

class PayloadModel {
  PayloadModel({
    this.title,
    this.body,
    this.orderId,
    this.image,
    this.type,
  });

  String? title;
  String? body;
  String? orderId;
  String? image;
  String? type;

  factory PayloadModel.fromRawJson(String str) =>
      PayloadModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
        title: json["title"],
        body: json["body"],
        orderId: json["order_id"],
        image: json["image"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "order_id": orderId,
        "image": image,
        "type": type,
      };
}
