import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Result App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainActivity(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  // Hàm để yêu cầu kết quả từ ResultActivity
  Future<void> _requestResult() async {
    double a = double.tryParse(_aController.text) ?? 0;
    double b = double.tryParse(_bController.text) ?? 0;

    // Navigate to ResultActivity và chờ kết quả trả về
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultActivity(a: a, b: b),
      ),
    );

    // Nếu có kết quả trả về, hiển thị trong EditText
    if (result != null) {
      setState(() {
        _resultController.text = result.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainActivity'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.purple, width: 3),
                ),
              ),
              child: Center(
                child: Text(
                  'Yêu cầu kết quả',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Input A
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Nhập A:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _aController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Input B
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Nhập B:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _bController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Result field
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Kết quả:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _resultController,
                    readOnly: true, // Chỉ đọc, không cho phép edit
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Request button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _requestResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'YÊU CẦU KẾT QUẢ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _resultController.dispose();
    super.dispose();
  }
}

// Result Activity
class ResultActivity extends StatefulWidget {
  final double a;
  final double b;

  const ResultActivity({
    super.key,
    required this.a,
    required this.b,
  });

  @override
  _ResultActivityState createState() => _ResultActivityState();
}

class _ResultActivityState extends State<ResultActivity> {
  late TextEditingController _aController;
  late TextEditingController _bController;

  @override
  void initState() {
    super.initState();
    _aController = TextEditingController(text: widget.a.toString());
    _bController = TextEditingController(text: widget.b.toString());
  }

  // Trả về tổng
  void _returnSum() {
    double a = double.tryParse(_aController.text) ?? widget.a;
    double b = double.tryParse(_bController.text) ?? widget.b;
    double sum = a + b;
    Navigator.pop(context, sum);
  }

  // Trả về hiệu
  void _returnDifference() {
    double a = double.tryParse(_aController.text) ?? widget.a;
    double b = double.tryParse(_bController.text) ?? widget.b;
    double difference = a - b;
    Navigator.pop(context, difference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ResultActivity'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.purple, width: 3),
                ),
              ),
              child: Center(
                child: Text(
                  'Xử lý kết quả',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Input A
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Nhận A:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _aController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Input B
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Nhận B:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _bController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _returnSum,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'TRẢ VỀ TỔNG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _returnDifference,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'TRẢ VỀ HIỆU',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }
}