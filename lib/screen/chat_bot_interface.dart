import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ChatInterface extends StatefulWidget {
  const ChatInterface({super.key});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  ChatUser mySelf = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'BookBuddy');
  List<ChatMessage> messages = [];
  List<ChatUser> typing = [];
  final Uri url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['GEMINI_API_KEY']}",
  );
  final headers = {'Content-Type': 'application/json'};

  @override
  void initState() {
    super.initState();
    typing = [];
  }

  Future<void> getdata(ChatMessage text) async {
    setState(() {
      typing.add(geminiUser);
      messages.insert(0, text);
    });

    final dataToGemini = {
      "contents": [
        {
          "parts": [
            {"text": text.text},
          ],
        },
      ],
    };

    await http.post(url, headers: headers, body: jsonEncode(dataToGemini)).then((
      response,
    ) {
      if (response.statusCode == 200) {
        final ResponseFromGemini = jsonDecode(response.body);
        print(
          ResponseFromGemini['candidates'][0]['content']['parts'][0]['text'],
        );
        ChatMessage responseFromGemini = ChatMessage(
          text:
              ResponseFromGemini['candidates'][0]['content']['parts'][0]['text'],
          user: geminiUser,
          createdAt: DateTime.now(),
        );
        messages.insert(0, responseFromGemini);
        typing.remove(geminiUser);
        setState(() {
          messages = messages;
        });
      } else {
        // print("Error: ${response.statusCode}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: DashChat(
        currentUser: mySelf,
        messages: messages,
        typingUsers: typing,
        onSend: (ChatMessage message) {
          getdata(message);
        },
        inputOptions: const InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: Colors.black),
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.black,
          avatarBuilder: hamzaAvatar,
        ),
      ),
    );
  }

  Widget hamzaAvatar(ChatUser user, Function? onTap, Function? onLongPress) {
      return Center(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
            'https://thumbs.dreamstime.com/b/black-white-line-icon-chatbot-reading-book-isolated-transparent-background-innovation-science-concept-machine-learning-338164561.jpg',
          ),
          radius: 20,
        ),
      );
    
  }
}
