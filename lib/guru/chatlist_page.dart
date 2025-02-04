import 'package:aplikasi_ortu/guru/chat_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(primarySwatch: Colors.green),
      home: ChatListPage(),
    );
  }
}

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, String>> chats = [];

  void _addChat(String name, String phoneNumber) {
    setState(() {
      chats.add({
        'name': name,
        'phone': phoneNumber,
        'message': '',
        'time': _getCurrentTime(),
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
            title: Text(chats[index]['name']!),
            subtitle: Text('No. Telp: ${chats[index]['phone']}'),
            trailing: Text(chats[index]['time']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatData: chats[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
        child: Icon(Icons.chat),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                    _addChat(nameController.text, phoneController.text);
                    Navigator.pop(context);  // Close the bottom sheet
                  }
                },
                child: Text('Add User'),
              ),
            ],
          ),
        );
      },
    );
  }
}

