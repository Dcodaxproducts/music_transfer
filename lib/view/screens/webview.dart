// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print, use_build_context_synchronously, must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../utils/colors.dart';

class LoadWebView extends StatefulWidget {
  const LoadWebView({super.key});

  @override
  LoadWebViewState createState() => LoadWebViewState();
}

class LoadWebViewState extends State<LoadWebView>
    with SingleTickerProviderStateMixin {
  static const platform = MethodChannel('com.example.matrix_ai/proxy');
  static const String outlineKey =
      'ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpreTJsUnZhbnBHSVo4anRjb3JaVXlZ@51.195.149.176:51829/?outline=1';
  static const String ip = 'localhost';
  static const String port = '30114';

  bool isProxyRunning = false;

  Future<void> startProxy() async {
    try {
      log('Starting outline proxy on port $port ...');
      final result = await platform.invokeMethod<String>(
          'startOutlineProxy', {"key": outlineKey, "port": port, "ip": ip});
      log('result: $result');
      setState(() {
        isProxyRunning = true;
      });

      await enableWebviewProxy();
      await webViewController?.reload();
    } on PlatformException catch (e) {
      log('Exception in starting proxy $e');
    }
  }

  Future<void> stopProxy() async {
    try {
      log('Stopping outline proxy');
      final result = await platform.invokeMethod<String>('stopOutlineProxy');
      log('result: $result');
      setState(() {
        isProxyRunning = false;
      });
      await disableWebviewProxy();
      webViewController?.reload();
    } on PlatformException catch (e) {
      log('Exception in stopping proxy $e');
    }
  }

  Future<void> enableWebviewProxy() async {
    if (Platform.isIOS) return;
    var proxyAvailable =
        await WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE);

    if (proxyAvailable) {
      ProxyController proxyController = ProxyController.instance();

      await proxyController.clearProxyOverride();
      await proxyController.setProxyOverride(
          settings: ProxySettings(
        proxyRules: [ProxyRule(url: 'localhost:$port')],
      ));
    }
  }

  Future<void> disableWebviewProxy() async {
    if (Platform.isIOS) return;
    ProxyController proxyController = ProxyController.instance();
    await proxyController.clearProxyOverride();
  }

  // webview
  final GlobalKey webViewKey = GlobalKey();

  late PullToRefreshController _pullToRefreshController;
  CookieManager cookieManager = CookieManager.instance();
  InAppWebViewController? webViewController;
  double progress = 0;
  String url = 'https://www.google.com/';
  bool isLoading = false;
  final expiresDate =
      DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch;
  @override
  void initState() {
    super.initState();

    try {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(color: primaryColor),
        onRefresh: () async {
          if (Platform.isAndroid) {
            webViewController!.reload();
          } else if (Platform.isIOS) {
            webViewController!.loadUrl(
                urlRequest: URLRequest(url: await webViewController!.getUrl()));
          }
        },
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  InAppWebViewSettings options = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useOnDownloadStart: true,
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    cacheEnabled: true,
    userAgent:
        "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
    verticalScrollBarEnabled: false,
    horizontalScrollBarEnabled: false,
    transparentBackground: true,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
    useHybridComposition: true,
    thirdPartyCookiesEnabled: true,
    allowFileAccess: true,
    allowsInlineMediaPlayback: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
        actions: [
          // start proxy,
          if (!isProxyRunning)
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: startProxy,
            ),
          // stop proxy,
          if (isProxyRunning)
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: stopProxy,
            ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              initialSettings: options,
              pullToRefreshController: _pullToRefreshController,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer()),
              },
              onWebViewCreated: (controller) async {
                webViewController = controller;

                await cookieManager.setCookie(
                  url: WebUri(url),
                  name: "myCookie",
                  value: "myValue",
                  expiresDate: expiresDate,
                  isHttpOnly: false,
                  isSecure: true,
                );
              },
              onLoadStart: (controller, url) async {
                print('----loadstart---- $url');

                setState(() {
                  isLoading = true;
                });
                if (Platform.isAndroid) {
                  List<Cookie> cookies =
                      await cookieManager.getCookies(url: url!);
                  // print('---android cookies---$cookies');
                }
                if (Platform.isIOS) {
                  List<Cookie> iosCookies = await cookieManager.getAllCookies();
                  // print('---ios cookies---$iosCookies');
                }
                setState(() {
                  this.url = url.toString();
                });
              },
              onLoadStop: (controller, url) async {
                print('==load stop, url: $url');
                _pullToRefreshController.endRefreshing();

                setState(() {
                  this.url = url.toString();
                });
              },
              onReceivedError: (controller, url, message) async {
                _pullToRefreshController.endRefreshing();
                print('---load error ---$message');
              },
              onReceivedHttpError: (controller, url, description) {
                _pullToRefreshController.endRefreshing();
                print('---load http error----$description');
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  _pullToRefreshController.endRefreshing();
                  isLoading = false;
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onCloseWindow: (controller) async {
                //  webViewController!.evaluateJavascript(source:'document.cookie = "token=$token"');
              },
              onCreateWindow: (controller, createWindowRequest) async {
                return true;
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                print('--from onUpdateVisitedHistory--$url');

                setState(() {
                  this.url = url.toString();
                });
              },
              onConsoleMessage: (controller, message) {
                print('---console---$message');
              },
            ),
          ),
          if (isLoading) LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}
