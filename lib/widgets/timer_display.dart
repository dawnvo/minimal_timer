import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = getValueForScreenType<double>(
      context: context,
      watch: 60.0,
      mobile: 80.0,
    );

    // * 60초 이하일 경우
    if (seconds <= 60) {
      return Text(
        seconds.toString(),
        style: TextStyle(fontSize: fontSize),
      );
    }
    // * 60초 이상일 경우
    else {
      final int minutesLeft = seconds ~/ 60;
      final int secondsLeft = seconds % 60;

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            minutesLeft.toString(),
            style: TextStyle(fontSize: fontSize),
          ),
          Text(
            // * 10초 이하 포맷; 09... 08... 07... 06...
            secondsLeft < 10 ? '0$secondsLeft' : secondsLeft.toString(),
            style: TextStyle(
              fontSize: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
  }
}
