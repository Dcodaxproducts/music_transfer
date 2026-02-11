import 'package:flutter/material.dart';

// 🔴 setState violation (should use GetBuilder/Obx)
class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String name = "Hello World"; // 🟡 hardcoded string (should use .tr)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF5733), // 🟡 hardcoded color
      body: Padding(
        padding: EdgeInsets.all(16), // 🟡 hardcoded padding (should use AppPadding)
        child: Column(
          children: [
            Text(
              "Welcome to the app", // 🟡 hardcoded string
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // 🟡 hardcoded TextStyle
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // 🟡 hardcoded radius
              ),
              child: Image.network("https://example.com/image.png"), // 🟡 uncached image
            ),
            ElevatedButton(
              onPressed: () {
                setState(() { // 🔴 setState in GetX project
                  name = "Updated";
                });
              },
              child: Text("Click Me"),
            ),
          ],
        ),
      ),
    );
  }
}

String apiKey = "sk-1234567890abcdef"; // 🔴 hardcoded secret
