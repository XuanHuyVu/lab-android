import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BroadcastReceiver1',
      home: const SmsReceiverScreen(),
    );
  }
}

class SmsReceiverScreen extends StatefulWidget {
  const SmsReceiverScreen({super.key});

  @override
  State<SmsReceiverScreen> createState() => _SmsReceiverScreenState();
}

class _SmsReceiverScreenState extends State<SmsReceiverScreen> {
  final Telephony telephony = Telephony.instance;

  final String listenNumber = "0123456789"; // số cần nghe
  final String forwardNumber = "0987654321"; // số cần chuyển tiếp

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _listenIncomingSms();
  }

  void _requestPermissions() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != true) {
      debugPrint("Không có quyền đọc SMS");
    }
  }

  void _listenIncomingSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        String? sender = message.address;
        String? body = message.body;

        if (sender != null && sender.contains(listenNumber)) {
          _forwardSms(body ?? "");
        }
      },
      listenInBackground: false,
    );
  }

  void _forwardSms(String content) async {
    await telephony.sendSms(
      to: forwardNumber,
      message: content,
    );
    debugPrint("Đã chuyển tiếp tin nhắn tới $forwardNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BroadcastReceiver1")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () {},
          child: const Text(
            "SMS Receiver",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
