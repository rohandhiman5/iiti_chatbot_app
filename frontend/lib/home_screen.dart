import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isThinking = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _isThinking = true;
    });

    var url = Uri.parse('http://10.0.2.2:5000/ask');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'question': message}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isThinking = false;
          _messages.add({'sender': 'bot', 'text': json.decode(response.body)['answer']});
        });
      } else {
        setState(() {
          _isThinking = false;
          _messages.add({'sender': 'bot', 'text': 'Error: ${response.reasonPhrase}'});
        });
      }
    } catch (e) {
      setState(() {
        _isThinking = false;
        _messages.add({'sender': 'bot', 'text': 'Error: Could not connect to server.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.deepPurpleAccent),
                          SizedBox(height: 10),
                          Text(
                            'IITI Chatbot',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length + (_isThinking ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < _messages.length) {
                          bool isUser = _messages[index]['sender'] == 'user';
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.blueAccent : Colors.grey[800],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                _messages[index]['text']!,
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bot is thinking...',
                              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          );
                        }
                      },
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
