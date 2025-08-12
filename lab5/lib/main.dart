import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuyển đổi năm dương lịch',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ConvertYearPage(),
    );
  }
}

class ConvertYearPage extends StatefulWidget {
  const ConvertYearPage({super.key});

  @override
  State<ConvertYearPage> createState() => _ConvertYearPageState();
}

class _ConvertYearPageState extends State<ConvertYearPage> {
  final TextEditingController _yearController = TextEditingController();
  String _amYear = '';

  final List<String> _can = ['Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'];
  final List<String> _chi = ['Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'];

  void _convertYear() {
    int? duong = int.tryParse(_yearController.text);
    if (duong == null) {
      setState(() {
        _amYear = 'Năm không hợp lệ';
      });
      return;
    }

    // Tính can và chi theo năm âm lịch (căn cứ từ năm 1984 là Giáp Tý)
    int canIndex = (duong + 6) % 10; // Can bắt đầu từ Giáp = 0 tại năm 1984
    int chiIndex = (duong + 8) % 12; // Chi bắt đầu từ Tý = 0 tại năm 1984

    setState(() {
      _amYear = '${_can[canIndex]} ${_chi[chiIndex]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyển đổi năm dương lịch'),
      ),
      body: Container(
        color: Colors.green[700],
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Năm dương lịch nhập
            Row(
              children: [
                const Text(
                  'Năm dương lịch: ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      filled: true,
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nút chuyển đổi
            Center(
              child: ElevatedButton(
                onPressed: _convertYear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  fixedSize: const Size(150, 40),
                ),
                child: const Text('Chuyển đổi'),
              ),
            ),
            const SizedBox(height: 12),

            // Hiển thị năm âm lịch
            Row(
              children: [
                const Text(
                  'Năm âm lịch: ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.yellow,
                  child: Text(
                    _amYear,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
