import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/video_log_service.dart';

import '../screens/video_player_screen.dart';

class CalendarView extends StatelessWidget {
  final _sl = GetIt.instance;
  final String name;
  final String thumbnail;
  final String? videoPath;
  final String? videoUrl;
  final String id;
  final Function onRemove;

  CalendarView({required this.id, required this.name, required this.thumbnail, this.videoPath, required this.onRemove, Key? key, this.videoUrl }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),

          children: [
            SlidableAction(
              autoClose: false,
              onPressed: delete,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',

            ),
            SlidableAction(
              onPressed: doNothing,
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    VideoPlayerScreen(
                        videoPath: videoPath,
                        videoUrl: videoUrl,
                        canSave: false,
                    ))
            );
          },
          child: Ink(
            color: Colors.amberAccent,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(name),
                Image.network(thumbnail)
              ],
            ),
          ),
        )
      );
  }
  void doNothing(BuildContext buildContext){}

  void delete(BuildContext buildContext) {
    _sl.get<VideoLogService>().removeRecord(id);
    onRemove();
    final controller = Slidable.of(buildContext);
    controller?.dismiss(ResizeRequest(const Duration(milliseconds: 300), () {

    }),
    duration: const Duration(milliseconds: 300));
  }

}