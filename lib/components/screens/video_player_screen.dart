import 'package:flutter/material.dart';
import 'package:my_video_log/service/video_log_service.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_it/get_it.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final bool canSave;

  const VideoPlayerScreen({Key? key, required this.videoPath, required this.canSave }) : super(key: key);


  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();

}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  final sl = GetIt.instance;
  late VideoPlayerController _controller;
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();

  }

  Future _initVideoPlayer()  async {
    _controller = VideoPlayerController.file(File(widget.videoPath));

    _flickManager = FlickManager(videoPlayerController: _controller);
    // await _controller.initialize();
    // await _controller.setLooping(true);
    // await _controller.play();
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
            return FlickVideoPlayer(
              flickManager: _flickManager,
            );
          }
        },
      ),
      floatingActionButton: widget.canSave ? FloatingActionButton(
          onPressed: () {
            GallerySaver.saveVideo(widget.videoPath);
            sl.get<VideoLogService>().addVideoLogRecord(widget.videoPath, DateTime.now());
          },
          child: const Icon(Icons.save)
      ) : null,
    );

  }


  @override
  void deactivate() {
    super.deactivate();
    _controller.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _flickManager.dispose();
  }
}
