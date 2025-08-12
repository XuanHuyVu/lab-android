import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: BMICalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? bmi;
  String classification = '';

  void _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      return;
    }

    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      // Convert height from cm to m if needed
      if (height > 3) {
        height = height / 100;
      }

      setState(() {
        bmi = weight / (height * height);
        _classifyBMI(bmi!);
      });
    }
  }

  void _classifyBMI(double bmiValue) {
    if (bmiValue < 18) {
      classification = 'Người gầy';
    } else if (bmiValue >= 18 && bmiValue <= 24.9) {
      classification = 'Người bình thường';
    } else if (bmiValue >= 25 && bmiValue <= 29.9) {
      classification = 'Người béo phì độ I';
    } else if (bmiValue >= 30 && bmiValue <= 34.9) {
      classification = 'Người béo phì độ II';
    } else {
      classification = 'Người béo phì độ III';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.yellow[300],
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  'Chương trình tính chỉ số BMI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 0),

              // Main container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name input
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Nhập Tên:',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange, width: 2),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Height input
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Chiều Cao:',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: TextField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                ),
                                onChanged: (value) => _calculateBMI(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Weight input
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Cân Nặng:',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                ),
                                onChanged: (value) => _calculateBMI(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Calculate button
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _calculateBMI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            'Tính BMI',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      // BMI result
                      Row(
                        children: [
                          Text(
                            'BMI = ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1),
                                color: Colors.white,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                bmi != null ? bmi!.toStringAsFixed(2) : '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Classification result
                      Row(
                        children: [
                          Text(
                            'Chuẩn đoán:',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1),
                                color: Colors.white,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                classification,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}