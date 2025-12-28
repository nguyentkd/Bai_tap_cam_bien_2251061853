import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class ExplorerTool extends StatefulWidget {
  const ExplorerTool({super.key});
  @override
  State<ExplorerTool> createState() => _ExplorerToolState();
}

class _ExplorerToolState extends State<ExplorerTool> {
  String _locationMessage = "Đang lấy vị trí...";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _locationMessage = "Đang lấy vị trí...";
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Hãy bật GPS (Location Service)!";
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Quyền vị trí bị từ chối.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Quyền vị trí bị tắt vĩnh viễn. Vào Cài đặt để bật lại.";
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _locationMessage =
            "Lat: ${position.latitude}\nLong: ${position.longitude}\nAlt: ${position.altitude.toStringAsFixed(1)}m";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Không lấy được vị trí: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Explorer Tool")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[900],
            child: Text(_locationMessage,
                style: const TextStyle(color: Colors.green, fontSize: 18)),
          ),
          Expanded(
            child: StreamBuilder<MagnetometerEvent>(
              stream: magnetometerEventStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final event = snapshot.data!;
                double heading = atan2(event.y, event.x);
                return Center(
                  child: Transform.rotate(
                    angle: -heading,
                    child: const Icon(Icons.navigation,
                        size: 150, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
