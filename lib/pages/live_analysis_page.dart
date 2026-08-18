import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:larva_detector_app_v3/models/api_connection.dart';
import 'package:larva_detector_app_v3/models/database_helper.dart';

class LiveAnalysisPage extends StatefulWidget {
  const LiveAnalysisPage({super.key});

  @override
  State<LiveAnalysisPage> createState() => _LiveAnalysisPageState();
}

class _LiveAnalysisPageState extends State<LiveAnalysisPage> {
  final Dio dio = Dio();
  Timer? _timer;
  Uint8List? _currentFrame;
  Map<String, dynamic>? _currentData;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Fetch a frame every 4 seconds (adjust based on your server speed)
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _fetchLiveFrame();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLiveFrame() async {
    // Prevent overlapping requests if network is slow
    if (_isProcessing) return; 
    _isProcessing = true;

    try {
      // Assuming your Flask server exposes a merged endpoint for the live relay
      // that returns both the base64 image AND the json data in one request
      final response = await dio.get('${ApiConnection().base_url}/live_inference');
      
      if (response.statusCode == 200) {
        setState(() {
          _currentFrame = const Base64Decoder().convert(response.data['image_base64']);
          _currentData = response.data['result'];
          bool isCameraLagging = response.data['lagging'] ?? false;
  
          if (isCameraLagging) {
            print("Notice: Displaying cached frame due to camera connection stutter.");
  }
        });

        // Save to Database
        await DatabaseHelper.instance.insertAnalysis({
          'timestamp': DateTime.now().toIso8601String(),
          'stage_1': _currentData?['larva_stage']?['larva1'] ?? 0,
          'stage_2': _currentData?['larva_stage']?['larva2'] ?? 0,
          'stage_3': _currentData?['larva_stage']?['larva3'] ?? 0,
          'stage_4': _currentData?['larva_stage']?['larva4'] ?? 0,
          'stage_5': _currentData?['larva_stage']?['larva5'] ?? 0,
          'stage_6': _currentData?['larva_stage']?['larva6'] ?? 0,
          'total': _currentData?['larva_total'] ?? 0,
        });
      }
    } catch (e) {
      print("Live fetch error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Stream Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Video Frame View
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _currentFrame != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        _currentFrame!,
                        gaplessPlayback: true, // Prevents flickering between frames
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            
            // Stats Grid View
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(7, (index) {
                  int val = 0;
                  if (_currentData != null) {
                    if (index == 6) {
                      val = _currentData!['larva_total'] ?? 0;
                    } else {
                      val = _currentData!['larva_stage']?['larva${index + 1}'] ?? 0;
                    }
                  }
                  
                  return Container(
                    margin: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: Text(
                        index == 6 ? "Total: $val" : "Stage ${index + 1}: $val",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}