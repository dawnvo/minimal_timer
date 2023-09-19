import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // * 60초 이하일 경우
    if (seconds <= 60) {
      return Text(
        seconds.toString(),
        style: const TextStyle(fontSize: 80),
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
            style: const TextStyle(fontSize: 80),
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
