// Flutter Pacakges
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class HistoryCalendarPage extends StatefulWidget {
  @override
  _HistoryCalendarPageState createState() => _HistoryCalendarPageState();
}

class _HistoryCalendarPageState extends State<HistoryCalendarPage> {
  final List<WorkoutHistory> workoutHistory = globals.workoutHistory;

  EventList<Event> _markedDateMap;

  @override
  void initState() {
    if (workoutHistory.length > 0) {
      List<DateTime> _addedDateTimes = [];

      for (int i = 0; i < workoutHistory.length; i++) {
        final date = DateTime.parse(
            DateFormat('yyyy-MM-dd').format(workoutHistory[i].workoutTime));

        if (!_addedDateTimes.contains(date)) {
          _addedDateTimes.add(date);

          if (_markedDateMap == null) {
            _markedDateMap = new EventList<Event>(
              events: {
                date: [
                  new Event(
                    date: workoutHistory[i].workoutTime,
                  )
                ],
              },
            );
          } else {
            _markedDateMap.add(
              date,
              new Event(
                date: workoutHistory[i].workoutTime,
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
    return _HistoryCalendarPageView(this);
  }
}

class _HistoryCalendarPageView extends StatelessWidget {
  final _HistoryCalendarPageState state;

  _HistoryCalendarPageView(this.state);

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
                markedDatesMap: state._markedDateMap,
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
