import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bai10_intent_filter_main',
      home: const IntentFilterScreen(),
    );
  }
}

class IntentFilterScreen extends StatefulWidget {
  const IntentFilterScreen({super.key});

  @override
  State<IntentFilterScreen> createState() => _IntentFilterScreenState();
}

class _IntentFilterScreenState extends State<IntentFilterScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _openWebPage() async {
    String url = _controller.text.trim();
    if (!url.startsWith("http")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không mở được link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bai10_intent_filter_main")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Nhập Link Website",
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Nhập URL...",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _openWebPage,
              child: const Text(
                "SHOW WEB PAGE",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
