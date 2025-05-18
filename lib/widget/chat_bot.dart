import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ChatInterface extends StatefulWidget {
  final String bookName;
  const ChatInterface({super.key, required this.bookName});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  late final String prompt;

  final Uri url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['GEMINI_API_KEY']}",
  );
  final headers = {'Content-Type': 'application/json'};
  @override
  void initState() {
    super.initState();
    prompt = """
Strictly provide a chapter-wise summary of the book "${widget.bookName}".

Strictly provide a chapter-wise summary of the book titled: "${widget.bookName}".

Format:
Brief Introduction (Add one blank line after the heading)

1. What is the book about?
[Brief introduction here]

Overall Summary (Add one blank line after the heading)

2. Whole Book Summary:
[Complete book summary here]

Chapter-wise Summary (Add one blank line after the heading)

3. Chapter-wise Summary:
For each chapter, follow this format:

Chapter [Number]: [Chapter Title]  
[Summary here]

Important Rules:
- Do NOT add greetings, conclusions, or commentary.
- Only return summaries in the exact format above.

""";
  }

  Future<String> getdata() async {
    final dataToGemini = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(dataToGemini),
      );
      if (response.statusCode == 200) {
        final ResponseFromGemini = jsonDecode(response.body);
        final String geminiText =
            ResponseFromGemini['candidates'][0]['content']['parts'][0]['text'];

        return geminiText;
      } else {
        print("Error: ${response.statusCode}");
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Exception: $e");
      return "Exception: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          print(snapshot.data);
          return SingleChildScrollView(
            child: Text(
              snapshot.data ?? 'No summary found.',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }
}
