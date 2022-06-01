import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/components/buttons/calendar_view.dart';
import 'package:my_video_log/components/domains/log_record.dart';
import 'package:my_video_log/service/video_log_service.dart';

class CalenderTab extends StatefulWidget {
  const CalenderTab({Key? key}) : super(key: key);

  @override
  State<CalenderTab> createState() => _CalenderTabState();
}

class _CalenderTabState extends State<CalenderTab> {
  final _sl = GetIt.instance;
  late Future<List<LogRecord>> recordList;

  @override
  void initState() {
    super.initState();
    recordList = _sl.get<VideoLogService>().loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LogRecord>>(future: _sl.get<VideoLogService>().loadRecords(),
        builder:(context , snapshot) {
            return RefreshIndicator(
              child: _listView(snapshot),
              onRefresh: _pullRefresh
            );
        });
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if(snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: CalendarView(snapshot.data[index].id,
                snapshot.data[index].date.toString(),
                snapshot.data[index].thumbnailUrl,
                snapshot.data[index].videoPath,
              _pullRefresh,
            ),

          );
        },
      );
    } else if(snapshot.hasError) {
      return const Center(
        child: Text('Load error'),
      );
    } else {
      return const Center(
        child: Text("Loading..."),
      );
    }
  }



  Future<void> _pullRefresh() async {
    List<LogRecord> refreshRecords = await _sl.get<VideoLogService>().loadRecords();
    setState(() {
      recordList = Future.value(refreshRecords);
    });

  }
}
