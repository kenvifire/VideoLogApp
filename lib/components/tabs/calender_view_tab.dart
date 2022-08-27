import 'package:flutter/material.dart';
import 'package:my_video_log/components/domains/log_record.dart';
import 'package:my_video_log/service/video_log_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../buttons/calendar_view.dart';
import '../domains/Event.dart';

class CalenderViewTab extends StatefulWidget {
  const CalenderViewTab({Key? key}) : super(key: key);

  @override
  State<CalenderViewTab> createState() => _CalenderViewTabState();
}

class _CalenderViewTabState extends State<CalenderViewTab> {
  final _sl = GetIt.instance;
  final formatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm');

  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay({}, _selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(Map<String, List<LogRecord>> logs, DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, focusedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(logs, selectedDay);
    }
  }

  void _onRangeSelected(Map<String, List<LogRecord>> logs, DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(logs, start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(logs, start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(logs, end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _loadData(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (DateTime day)  {
                  return _getEventsForDay(snapshot.data!, day);
                },
                onDaySelected: (DateTime selected, DateTime focused) {
                  return _onDaySelected(snapshot.data!, selected, focused);
                },
                onRangeSelected: (start, end, focused) {
                  return _onRangeSelected(snapshot.data!, start, end, focused);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title:  CalendarView(
                              id: value[index].logRecord.id,
                              name: value[index].title,
                              thumbnail: value[index].logRecord.thumbnailUrl,
                              videoPath: value[index].logRecord.videoPath,
                              videoUrl: value[index].logRecord.videoUrl,
                              onRemove: () {
                                _onRemove(value[index].logRecord.id);
                              }
                          ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else if(snapshot.hasError) {
          return Center(
            child: Text("Error loading data, ${snapshot.error}"),
          );
        } else {
          return const Center(
            child: Text("Loading..."),
          );
        }
      }
    );

  }

  _onRemove(String id) {
    _selectedEvents.value = List.from(_selectedEvents.value)..removeWhere((element) => element.logRecord.id == id);
  }

  _loadData() async {
    return await _sl.get<VideoLogService>().loadRecordsByDate();
  }
  List<Event> _getEventsForDay(Map<String, List<LogRecord>> logs, DateTime day) {
    List<LogRecord> logsForDate = logs[formatter.format(day)] ?? [];
    return logsForDate.map((log) => Event(timeFormatter.format(log.date), log)).toList();
  }


  List<Event> _getEventsForRange(Map<String, List<LogRecord>> logs, DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(logs, d),
    ];
  }


  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
