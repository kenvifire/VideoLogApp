import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_video_log/components/dialog/alert_dialog.dart';
import 'package:my_video_log/service/user_preference_service.dart';
import 'package:my_video_log/service/video_log_service.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_it/get_it.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'dart:io' as io;

import '../domains/result.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoPath;
  final bool canSave;
  final String? videoUrl;

  const VideoPlayerScreen({Key? key, this.videoPath, this.videoUrl, required this.canSave }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();

}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  final sl = GetIt.instance;
  late VideoPlayerController _controller;
  late FlickManager _flickManager;
  late bool canSave;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    canSave = widget.canSave;
  }

  Future _initVideoPlayer()  async {
    if(widget.videoPath != null && await io.File(widget.videoPath!).exists()) {
      _controller = VideoPlayerController.file(File(widget.videoPath!));
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl!);
    }

    _flickManager = FlickManager(videoPlayerController: _controller);
    // await _controller.initialize();
    // await _controller.setLooping(true);
    // await _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Preview'),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: FutureBuilder(
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
      ),
      floatingActionButton: canSave ? FloatingActionButton(
          onPressed: () async {
            setState(() {
              showSpinner = true;
            });
            GallerySaver.saveVideo(widget.videoPath!);
            Result result = await sl.get<VideoLogService>().addVideoLogRecord(widget.videoPath!, DateTime.now(),
                uploadToCloud: (await sl.get<UserPreferenceService>().getUserPreference()).saveToCloud);
            if(result.success) {
              setState(() {
                canSave = false;
                showSpinner = false;
              });
              showMyDialog(context, 'Upload succeed');
            } else {
              setState(() {
                showSpinner = false;
              });
              showMyDialog(context, 'Upload failed', content: result.code, cancelTitle: 'OK');
            }
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
