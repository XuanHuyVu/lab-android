import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controllerA = TextEditingController(text: '0');
  final TextEditingController _controllerB = TextEditingController(text: '0');
  double _result = 0;

  void _calculate(String operator) {
    double a = double.tryParse(_controllerA.text) ?? 0;
    double b = double.tryParse(_controllerB.text) ?? 0;
    double res = 0;

    switch (operator) {
      case 'add':
        res = a + b;
        break;
      case 'sub':
        res = a - b;
        break;
      case 'mul':
        res = a * b;
        break;
      case 'div':
        if (b != 0) {
          res = a / b;
        } else {
          res = double.infinity;
        }
        break;
    }

    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputRow('Nhập a', _controllerA),
            _buildInputRow('Nhập b', _controllerB),
            _buildResultRow('Kết quả', _result),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCalcButton('TỔNG', () => _calculate('add')),
                _buildCalcButton('HIỆU', () => _calculate('sub')),
                _buildCalcButton('TÍCH', () => _calculate('mul')),
                _buildCalcButton('THƯƠNG', () => _calculate('div')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                border: UnderlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, double result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Text(
            result.isInfinite ? 'Không xác định' : result.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcButton(String title, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
