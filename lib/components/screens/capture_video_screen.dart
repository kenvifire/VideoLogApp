import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:my_video_log/components/screens/video_player_screen.dart';
import 'dart:async';

class CaptureVideoScreen extends StatefulWidget {
  static String id = "capture_video_screen";

  final CameraDescription camera;

  const CaptureVideoScreen({Key? key, required this.camera}) : super(key: key);

  @override
  CaptureVideoState createState() => CaptureVideoState();

}

class CaptureVideoState extends State<CaptureVideoScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        widget.camera,
        ResolutionPreset.medium
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            if (!_isCapturing) {
              await _controller.startVideoRecording();
              setState(() {
                _isCapturing = true;
              });
            } else {
              final file = await _controller.stopVideoRecording();
              setState(() {
                _isCapturing = false;
              });

              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      VideoPlayerScreen(
                          videoPath: file.path,
                        canSave: true,
                      ))
              );
            }
          } catch (e) {
            print(e.toString());
          }
        },
        child: _isCapturing ? const Icon(Icons.camera) : const Icon(
            Icons.stop_circle_outlined),
      ),
    );
  }
}