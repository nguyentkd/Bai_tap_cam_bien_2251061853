import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionTracker extends StatefulWidget {
  const MotionTracker({super.key});
  @override
  State<MotionTracker> createState() => _MotionTrackerState();
}

class _MotionTrackerState extends State<MotionTracker> {
  int _shakeCount = 0;
  static const double _shakeThreshold = 15.0;
  DateTime _lastShakeTime = DateTime.now();
  Color _bgColor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(title: const Text("Motion Tracker")),
      body: StreamBuilder<UserAccelerometerEvent>(
        stream: userAccelerometerEventStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: Text("Đang chờ cảm biến..."));
          
          final event = snapshot.data!;
          double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

          if (acceleration > _shakeThreshold) {
            final now = DateTime.now();
            if (now.difference(_lastShakeTime).inMilliseconds > 500) {
              _lastShakeTime = now;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _shakeCount++;
                  _bgColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                });
              });
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.vibration, size: 80, color: Colors.white),
                Text("SHAKE: $_shakeCount", style: const TextStyle(fontSize: 40, color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}