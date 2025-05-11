import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart'; // Import flutter_animate package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  bool _isTyping = false;
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat UI with Reactions')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index])
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0), duration: 300.ms); // Correct scale animation
                },
              ),
            ),
            if (_isTyping) _buildTypingIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (text) {
                        setState(() {
                          _isTyping = text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    onLongPress: _toggleButtonScale,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: _isButtonPressed ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _isButtonPressed ? Colors.greenAccent : Colors.blueAccent,
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.insert(0, Message(text: _controller.text, isUser: true));
        _controller.clear();
        _isTyping = false;
      });
      Timer(Duration(seconds: 1), () {
        setState(() {
          _messages.insert(0, Message(text: 'Received: ${_messages.first.text}', isUser: false));
        });
      });
    }
  }

  void _toggleButtonScale() {
    setState(() {
      _isButtonPressed = !_isButtonPressed;
    });
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(),
          SizedBox(width: 5),
          _buildDot(),
          SizedBox(width: 5),
          _buildDot(),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return AnimatedOpacity(
      opacity: _isTyping ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: CircleAvatar(
        radius: 5,
        backgroundColor: Colors.grey,
      ),
    ).animate().scale(begin: Offset(0.5, 0.5), end: Offset(1.0, 1.0), duration: 300.ms); // Add scaling animation to dots
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 5),
                  _buildReactions(),
                ],
              ),
            ).animate().scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0), duration: 300.ms), // Correct scale animation
          ],
        ),
      ),
    );
  }

  Widget _buildReactions() {
    return Row(
      children: [
        GestureDetector(
          child: Icon(Icons.favorite, color: Colors.red),
          onTap: () => print('Liked'),
        ),
        SizedBox(width: 10),
        GestureDetector(
          child: Icon(Icons.sentiment_satisfied, color: Colors.yellow),
          onTap: () => print('Happy'),
        ),
        SizedBox(width: 10),
        GestureDetector(
          child: Icon(Icons.thumb_up, color: Colors.blue),
          onTap: () => print('Thumbed Up'),
        ),
      ],
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
