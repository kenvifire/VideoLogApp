import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:my_video_log/service/video_log_service.dart';
import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

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
          if(snapshot.connectionState == ConnectionState.done) {
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
            if(!_isCapturing) {
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
                  MaterialPageRoute(builder: (context) => VideoPlayerScreen(
                    videoPath: file.path
                  ))
              );
            }

          } catch(e) {
            print(e.toString());
          }
        },
        child: _isCapturing? const Icon(Icons.camera) : const Icon(Icons.stop_circle_outlined),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({Key? key, required this.videoPath}) : super(key: key);


  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();

}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
  }

  Future _initVideoPlayer()  async {
    _controller = VideoPlayerController.file(File(widget.videoPath));

    await _controller.initialize();
    await _controller.setLooping(true);
    await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(onPressed: () {
            print('do something with the file');
          }, icon: const Icon(Icons.check))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if(state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_controller);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GallerySaver.saveVideo(widget.videoPath);
          sl.get<VideoLogService>().addVideoLogRecord(widget.videoPath, DateTime.now());
        },
        child: const Icon(Icons.save)
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

