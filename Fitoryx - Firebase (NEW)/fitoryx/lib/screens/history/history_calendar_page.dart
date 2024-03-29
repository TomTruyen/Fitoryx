import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/history/history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class HistoryCalendarPage extends StatefulWidget {
  final List<WorkoutHistory> history;

  const HistoryCalendarPage({Key? key, required this.history})
      : super(key: key);

  @override
  State<HistoryCalendarPage> createState() => _HistoryCalendarPageState();
}

class _HistoryCalendarPageState extends State<HistoryCalendarPage> {
  EventList<Event> _markedDatesMap = EventList<Event>(events: {});

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.history.length; i++) {
      DateTime date = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(widget.history[i].date),
      );

      if (!_markedDatesMap.events.containsKey(date)) {
        _markedDatesMap.add(
          date,
          Event(id: i, date: date),
        );
      }
    }

    setState(() {
      _markedDatesMap = _markedDatesMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          const SliverAppBar(
            floating: true,
            pinned: true,
            leading: CloseButton(),
            title: Text('Calendar'),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: CalendarCarousel(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              selectedDateTime: null,
              iconColor: Theme.of(context).primaryColor,
              headerTextStyle: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColor,
              ),
              firstDayOfWeek: 1,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              todayTextStyle:
                  DateTime.now().weekday == 6 || DateTime.now().weekday == 7
                      ? const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        )
                      : const TextStyle(color: Colors.black),
              weekdayTextStyle: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).primaryColor,
              ),
              weekendTextStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              markedDatesMap: _markedDatesMap,
              markedDateShowIcon: true,
              markedDateIconBuilder: (Event event) {
                return Opacity(
                  opacity: 0.2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
              daysHaveCircularBorder: true,
              onDayPressed: (date, list) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => HistoryPage(day: date),
                  ),
                );
                // show all workouts from that specific day
              },
              onDayLongPressed: (date) {},
              onCalendarChanged: (date) {},
              onHeaderTitlePressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
