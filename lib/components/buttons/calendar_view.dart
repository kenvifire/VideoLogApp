import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/video_log_service.dart';

class CalendarView extends StatelessWidget {
  final _sl = GetIt.instance;
  final String name;
  final String thumbnail;
  final String videoPath;
  final String id;

  CalendarView(this.id, this.name, this.thumbnail, this.videoPath, {Key? key }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Slidable(
        key: key,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),

          children: [
            SlidableAction(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Image.network(thumbnail)
          ],
        )
      );
  }
  void doNothing(BuildContext buildContext){}

  void delete(BuildContext buildContext) {
    _sl.get<VideoLogService>().removeRecord(id);
  }

}