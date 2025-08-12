import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông tin cá nhân',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonalInfoForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final TextEditingController _nameController = TextEditingController(text: "Doan Ai Nuong");
  final TextEditingController _idController = TextEditingController(text: "250592829");
  final TextEditingController _additionalInfoController = TextEditingController(text: "Senior Programmer\nSenior saler");

  String _selectedDegree = "Đại học";
  final List<String> _selectedInterests = ["Đọc báo", "Đọc coding"];

  void _showResult() {
    String interests = _selectedInterests.join("- ");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          name: _nameController.text,
          id: _idController.text,
          degree: _selectedDegree,
          interests: interests,
          additionalInfo: _additionalInfoController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.teal[600],
                ),
                child: Text(
                  'Thông tin cá nhân',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Name field
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text('Họ tên:', style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // ID field
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text('CMND:', style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _idController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Degree section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Bằng cấp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Radio buttons
                      Row(
                        children: [
                          Radio<String>(
                            value: "Trung cấp",
                            groupValue: _selectedDegree,
                            onChanged: (value) {
                              setState(() {
                                _selectedDegree = value!;
                              });
                            },
                          ),
                          Text("Trung cấp"),
                          Radio<String>(
                            value: "Cao đẳng",
                            groupValue: _selectedDegree,
                            onChanged: (value) {
                              setState(() {
                                _selectedDegree = value!;
                              });
                            },
                          ),
                          Text("Cao đẳng"),
                          Radio<String>(
                            value: "Đại học",
                            groupValue: _selectedDegree,
                            onChanged: (value) {
                              setState(() {
                                _selectedDegree = value!;
                              });
                            },
                          ),
                          Text("Đại học"),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Interests section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Sở thích',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Checkboxes
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedInterests.contains("Đọc báo"),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedInterests.add("Đọc báo");
                                } else {
                                  _selectedInterests.remove("Đọc báo");
                                }
                              });
                            },
                          ),
                          Text("Đọc báo"),
                          Checkbox(
                            value: _selectedInterests.contains("Đọc sách"),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedInterests.add("Đọc sách");
                                } else {
                                  _selectedInterests.remove("Đọc sách");
                                }
                              });
                            },
                          ),
                          Text("Đọc sách"),
                          Checkbox(
                            value: _selectedInterests.contains("Đọc coding"),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _selectedInterests.add("Đọc coding");
                                } else {
                                  _selectedInterests.remove("Đọc coding");
                                }
                              });
                            },
                          ),
                          Text("Đọc coding"),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Additional info section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Text(
                          'Thông tin bổ sung',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Text area
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                          ),
                          child: TextField(
                            controller: _additionalInfoController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Submit button
                      ElevatedButton(
                        onPressed: _showResult,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'Gửi thông tin',
                          style: TextStyle(fontSize: 16),
                        ),
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
}

class ResultScreen extends StatelessWidget {
  final String name;
  final String id;
  final String degree;
  final String interests;
  final String additionalInfo;

  const ResultScreen({
    super.key,
    required this.name,
    required this.id,
    required this.degree,
    required this.interests,
    required this.additionalInfo,
  });

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Question'),
            ],
          ),
          content: Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('NO', style: TextStyle(color: Colors.cyan)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to form
              },
              child: Text('YES', style: TextStyle(color: Colors.cyan)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              width: 300,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[200],
                    ),
                    child: Text(
                      'Thông tin cá nhân',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan[700],
                      ),
                    ),
                  ),

                  // Content
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(id, style: TextStyle(fontSize: 14)),
                        Text(degree, style: TextStyle(fontSize: 14)),
                        Text(interests, style: TextStyle(fontSize: 14)),

                        SizedBox(height: 8),
                        Text('-----------------------------', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),

                        Text('Thông tin bổ sung:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(additionalInfo.replaceAll('\n', '\n'), style: TextStyle(fontSize: 14)),

                        SizedBox(height: 8),
                        Text('-----------------------------', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),

                  // Close button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showExitDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Đóng',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}