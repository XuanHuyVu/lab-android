import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TemperatureConverterPage(),
    );
  }
}

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final TextEditingController _inputController = TextEditingController();

  String _result = '';
  String _resultLabel = '';

  void _convertToCelsius() {
    final input = double.tryParse(_inputController.text);
    if (input == null) {
      _showError();
      return;
    }
    // Fahrenheit to Celsius
    final celsius = (input - 32) * 5 / 9;
    setState(() {
      _result = celsius.toStringAsFixed(2);
      _resultLabel = 'Celsius';
    });
  }

  void _convertToFahrenheit() {
    final input = double.tryParse(_inputController.text);
    if (input == null) {
      _showError();
      return;
    }
    // Celsius to Fahrenheit
    final fahrenheit = input * 9 / 5 + 32;
    setState(() {
      _result = fahrenheit.toStringAsFixed(2);
      _resultLabel = 'Fahrenheit';
    });
  }

  void _clear() {
    _inputController.clear();
    setState(() {
      _result = '';
      _resultLabel = '';
    });
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid number')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fahrenheit',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _inputController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter temperature',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _resultLabel,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _convertToCelsius,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Convert To Celsius'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _convertToFahrenheit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Convert To Fahrenheit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.black,
                ),
                child: const Text('Clear'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
