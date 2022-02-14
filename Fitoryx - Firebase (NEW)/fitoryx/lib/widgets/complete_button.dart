import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/providers/workout_change_notifier.dart';
import 'package:fitoryx/screens/workout/rest_timer_page.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteButton extends StatefulWidget {
  final bool started;
  final int exerciseIndex;
  final int setIndex;
  final WorkoutChangeNotifier workout;

  const CompleteButton({
    Key? key,
    this.started = false,
    required this.exerciseIndex,
    required this.setIndex,
    required this.workout,
  }) : super(key: key);

  @override
  State<CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<CompleteButton> {
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var settings = await _settingsService.getSettings();

    if (mounted) {
      setState(() {
        _settings = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 0, 8, 0),
      child: AbsorbPointer(
        absorbing: !widget.started,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: widget.workout.exercises[widget.exerciseIndex]
                      .sets[widget.setIndex].completed
                  ? Colors.green[400]
                  : null,
            ),
            child: Icon(
              Icons.check,
              color: widget.workout.exercises[widget.exerciseIndex]
                      .sets[widget.setIndex].completed
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          onTap: () {
            if (_settings.restEnabled &&
                !widget.workout.exercises[widget.exerciseIndex]
                    .sets[widget.setIndex].completed) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => RestTimerPage(
                    restSeconds: widget
                        .workout.exercises[widget.exerciseIndex].restSeconds,
                    vibrateEnabled: _settings.vibrateEnabled,
                  ),
                ),
              );
            }

            widget.workout.toggleSet(widget.exerciseIndex, widget.setIndex);
          },
        ),
      ),
    );
  }
}
