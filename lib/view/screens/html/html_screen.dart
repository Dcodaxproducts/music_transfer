import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlScreen extends StatelessWidget {
  final String html;
  const HtmlScreen({required this.html, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: pagePadding.copyWith(top: 0),
          child: Html(
            data: html,
            style: {
              'body': Style(
                fontWeight: FontWeight.normal,
              ),
              'p': Style(
                fontWeight: FontWeight.normal,
              ),
              'a': Style(
                fontWeight: FontWeight.normal,
              ),
            },
            onLinkTap: (url, _, ___) async {
              if (await canLaunchUrl(Uri.parse(url!))) {
                await launchUrl(Uri.parse(url));
              }
            },
          ),
        ),
      ),
    );
  }
}
