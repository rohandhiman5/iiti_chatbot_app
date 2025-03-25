import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  WebViewController? webViewController;
  String? mapUrl;

  Future<void> fetchMap() async {
    final String start = startController.text.trim();
    final String end = endController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide both start and end locations')),
      );
      return;
    }

    try {
      // Replace with your Flask server's IP or domain
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/get_map'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'start': start, 'end': end}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          mapUrl = 'http://10.0.2.2:8000/' + responseData['map_path'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch map')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: startController,
              decoration: InputDecoration(labelText: 'Start Location'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: endController,
              decoration: InputDecoration(labelText: 'End Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchMap,
              child: Text('Get Map'),
            ),
            SizedBox(height: 20),
            if (mapUrl != null)
              Expanded(
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse(mapUrl!)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}