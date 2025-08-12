import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidu_Ptb2',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
      ),
      home: QuadraticEquationSolver(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuadraticEquationSolver extends StatefulWidget {
  @override
  _QuadraticEquationSolverState createState() => _QuadraticEquationSolverState();
}

class _QuadraticEquationSolverState extends State<QuadraticEquationSolver> {
  final TextEditingController _aController = TextEditingController(text: "2");
  final TextEditingController _bController = TextEditingController(text: "5");
  final TextEditingController _cController = TextEditingController(text: "3");

  String result = "Pt có 2 No: x1=-1.50; x2=-1.50";

  void _solve() {
    try {
      double a = double.parse(_aController.text);
      double b = double.parse(_bController.text);
      double c = double.parse(_cController.text);

      if (a == 0) {
        if (b == 0) {
          if (c == 0) {
            setState(() {
              result = "Phương trình vô số nghiệm";
            });
          } else {
            setState(() {
              result = "Phương trình vô nghiệm";
            });
          }
        } else {
          double x = -c / b;
          setState(() {
            result = "Pt bậc 1 có nghiệm: x = ${x.toStringAsFixed(2)}";
          });
        }
      } else {
        double delta = b * b - 4 * a * c;

        if (delta < 0) {
          setState(() {
            result = "Phương trình vô nghiệm";
          });
        } else if (delta == 0) {
          double x = -b / (2 * a);
          setState(() {
            result = "Pt có nghiệm kép: x = ${x.toStringAsFixed(2)}";
          });
        } else {
          double x1 = (-b + sqrt(delta)) / (2 * a);
          double x2 = (-b - sqrt(delta)) / (2 * a);
          setState(() {
            result = "Pt có 2 No: x1=${x1.toStringAsFixed(2)}; x2=${x2.toStringAsFixed(2)}";
          });
        }
      }
    } catch (e) {
      setState(() {
        result = "Vui lòng nhập số hợp lệ";
      });
    }
  }

  void _continue() {
    _aController.clear();
    _bController.clear();
    _cController.clear();
    setState(() {
      result = "";
    });
  }

  void _exit() {
    // In a real app, you might navigate back or close the app
    // For now, we'll just clear everything
    _continue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.android, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text(
              'Vidu_Ptb2',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Giải phương trình bậc 2',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Input a
                  Row(
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Text(
                          'Nhập a:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _aController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Input b
                  Row(
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Text(
                          'Nhập b:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _bController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Input c
                  Row(
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                        ),
                        child: Text(
                          'Nhập c:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _cController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _continue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Tiếp tục',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _solve,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Giải PT',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _exit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Thoát',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Result
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }
}