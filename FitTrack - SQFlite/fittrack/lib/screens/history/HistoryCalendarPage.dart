import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/workout/Workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class HistoryCalendarPage extends StatefulWidget {
  final List<Workout> workoutsHistory;

  HistoryCalendarPage({this.workoutsHistory = const []});

  @override
  _HistoryCalendarPageState createState() => _HistoryCalendarPageState();
}

class _HistoryCalendarPageState extends State<HistoryCalendarPage> {
  EventList<Event> markedDatesMap;

  @override
  void initState() {
    super.initState();

    fillMarkedDatesMap();
  }

  void fillMarkedDatesMap() {
    EventList<Event> _markedDatesMap;

    for (int i = 0; i < widget.workoutsHistory.length; i++) {
      DateTime date = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(
          DateTime.fromMillisecondsSinceEpoch(
            widget.workoutsHistory[i].timeInMillisSinceEpoch,
          ),
        ),
      );

      if (_markedDatesMap == null) {
        _markedDatesMap = new EventList<Event>(
          events: {
            date: [
              new Event(
                id: i,
                date: date,
              )
            ],
          },
        );
      } else if (!_markedDatesMap.events.containsKey(date)) {
        _markedDatesMap.add(
          date,
          new Event(id: i, date: date),
        );
      }
    }

    setState(() {
      markedDatesMap = _markedDatesMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
            title: Text(
              'Calendar',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: CalendarCarousel(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              selectedDateTime: null,
              iconColor: Colors.blue[700],
              headerTextStyle: TextStyle(
                fontSize: 20.0,
                color: Colors.blue[700],
              ),
              firstDayOfWeek: 1,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              todayTextStyle:
                  DateTime.now().weekday == 6 || DateTime.now().weekday == 7
                      ? TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        )
                      : TextStyle(color: Colors.black),
              weekdayTextStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.blue[700],
              ),
              weekendTextStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              markedDatesMap: markedDatesMap,
              markedDateShowIcon: true,
              markedDateIconBuilder: (Event event) {
                return Opacity(
                  opacity: 0.2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
              daysHaveCircularBorder: true,
              disableDayPressed: true,
              onDayPressed: (date, list) {},
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
