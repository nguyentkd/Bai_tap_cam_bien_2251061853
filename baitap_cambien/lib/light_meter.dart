import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightMeter extends StatefulWidget {
  const LightMeter({super.key});
  @override
  State<LightMeter> createState() => _LightMeterState();
}

class _LightMeterState extends State<LightMeter> {
  int _luxValue = 0;
  StreamSubscription? _subscription;
  bool? _hasSensor;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Future<void> _startListening() async {
    try {
      final hasSensor = await LightSensor.hasSensor();
      if (!mounted) return;
      setState(() {
        _hasSensor = hasSensor;
      });

      if (!hasSensor) return;

      _subscription = LightSensor.luxStream().listen(
        (lux) {
          if (!mounted) return;
          setState(() => _luxValue = lux);
        },
        onError: (e) {
          if (!mounted) return;
          setState(() {
            _error = e.toString();
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = _luxValue < 50;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(title: const Text("Light Meter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb,
                size: 100, color: isDark ? Colors.grey : Colors.orange),
            if (_error != null)
              Text(
                "Lỗi: $_error",
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              )
            else if (_hasSensor == false)
              Text(
                "Thiết bị không có cảm biến ánh sáng!",
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              )
            else
              Text(
                "$_luxValue LUX",
                style: TextStyle(
                  fontSize: 60,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
