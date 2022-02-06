import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/utils/int_extension.dart';
import 'package:fitoryx/widgets/complete_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CompleteWorkoutPage extends StatefulWidget {
  final WorkoutHistory history;
  final int historyCount;

  const CompleteWorkoutPage({
    Key? key,
    required this.history,
    required this.historyCount,
  }) : super(key: key);

  @override
  State<CompleteWorkoutPage> createState() => _CompleteWorkoutPageState();
}

class _CompleteWorkoutPageState extends State<CompleteWorkoutPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(
      const Duration(milliseconds: 250),
      () => _controller.forward(from: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          const SliverAppBar(
            leading: CloseButton(),
          ),
          SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        bottom: 10,
                        child: Transform.rotate(
                          angle: 90,
                          child: Lottie.asset(
                            'assets/lottie/star.json',
                            controller: _controller,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            repeat: false,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Lottie.asset(
                          'assets/lottie/star.json',
                          controller: _controller,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          repeat: false,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 10,
                        child: Transform.rotate(
                          angle: -90,
                          child: Lottie.asset(
                            'assets/lottie/star.json',
                            controller: _controller,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            repeat: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Congratulations!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "You have completed your ${widget.historyCount.ordinal()} workout!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CompleteWorkoutCard(history: widget.history),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
