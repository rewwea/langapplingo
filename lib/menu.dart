import 'package:flutter/material.dart';
import 'lessons.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Learning App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lessons()),
                );
              },
              child: Text('Lessons', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Dictionary', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Settings', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}