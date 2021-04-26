import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

class HistoryCalendarPage extends StatefulWidget {
  final List<WorkoutHistory> history;

  HistoryCalendarPage({this.history});

  @override
  _HistoryCalendarPageState createState() => _HistoryCalendarPageState();
}

class _HistoryCalendarPageState extends State<HistoryCalendarPage> {
  EventList<Event> _markedDateMap;

  @override
  void initState() {
    if (widget.history.length > 0) {
      List<DateTime> _addedDateTimes = [];

      for (int i = 0; i < widget.history.length; i++) {
        final date = DateTime.parse(
            DateFormat('yyyy-MM-dd').format(widget.history[i].workoutTime));

        if (!_addedDateTimes.contains(date)) {
          _addedDateTimes.add(date);

          if (_markedDateMap == null) {
            _markedDateMap = new EventList<Event>(
              events: {
                date: [
                  new Event(
                    date: widget.history[i].workoutTime,
                  )
                ],
              },
            );
          } else {
            _markedDateMap.add(
              date,
              new Event(
                date: widget.history[i].workoutTime,
              ),
            );
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              forceElevated: true,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Future.delayed(
                    Duration(milliseconds: 100),
                    () => {popContextWhenPossible(context)},
                  );
                },
              ),
              title: Text('Calendar'),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: CalendarCarousel(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80.0,
                selectedDateTime: null,
                iconColor: Colors.black,
                headerTextStyle: TextStyle(
                    fontSize: 20.0, color: Theme.of(context).accentColor),
                todayBorderColor: Colors.transparent,
                todayButtonColor: Colors.transparent,
                todayTextStyle: TextStyle(color: Colors.black),
                weekdayTextStyle: TextStyle(
                    fontSize: 14.0, color: Theme.of(context).accentColor),
                weekendTextStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                markedDatesMap: _markedDateMap,
                markedDateWidget: Container(),
                markedDateCustomShapeBorder: CircleBorder(
                  side: BorderSide(color: Theme.of(context).accentColor),
                ),
                onDayPressed: (date, list) {},
                onDayLongPressed: (date) {},
                onCalendarChanged: (date) {},
                onHeaderTitlePressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
