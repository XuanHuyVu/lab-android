import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnExplicitIntent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainActivity(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main Activity
class MainActivity extends StatelessWidget {
  const MainActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.android, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'LearnExplicitIntent',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is main Activity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate to Child Activity
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildActivity()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Open Child Activity',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChildActivity extends StatelessWidget {
  const ChildActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.android, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'ChildActivity',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Ẩn nút back mặc định
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is Child Activity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate back to Main Activity
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Back to Main Activity',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}