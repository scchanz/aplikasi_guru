import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final Map<String, String> chatData;
  ChatPage({required this.chatData});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController messageController;
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    messages.add({
      'sender': widget.chatData['name']!,
      'message': 'Hello, welcome!',
      'time': _getCurrentTime(),
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute}';
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'You',
          'message': message,
          'time': _getCurrentTime(),
        });
      });

      if (message.toLowerCase().contains('khansa')) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            messages.add({
              'sender': 'Bot',
              'message': 'Kamu sangat cantik',
              'time': _getCurrentTime(),
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatData['name']}'),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isSentByUser = messages[index]['sender'] == 'You';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSentByUser ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Text(
                        messages[index]['message']!,
                        style: TextStyle(
                          color: isSentByUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendMessage(value);  // Kirim pesan saat tombol enter ditekan
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(messageController.text);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
