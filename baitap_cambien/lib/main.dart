import 'package:flutter/material.dart';
import 'motion_tracker.dart';
import 'explorer_tool.dart';
import 'light_meter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài Tập Cảm Biến")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MotionTracker()),
              ),
              child: const Text("Bài 1: Đo Chuyển Động (Lắc)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExplorerTool()),
              ),
              child: const Text("Bài 2: La Bàn & GPS"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LightMeter()),
              ),
              child: const Text("Bài 3: Đo Ánh Sáng"),
            ),
          ],
        ),
      ),
    );
  }
}
