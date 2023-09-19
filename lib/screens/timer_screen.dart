import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_timer/providers/timer.dart';
import 'package:minimal_timer/widgets/circular_progress_painter.dart';
import 'package:minimal_timer/widgets/layout.dart';
import 'package:minimal_timer/widgets/timer_button.dart';
import 'package:minimal_timer/widgets/timer_display.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final elapsedTime = timerState.seconds / timerState.initialSeconds;

    ref.listen(timerProvider, (prev, next) {
      if (prev != next && next.isRunning == false) {
        Navigator.of(context).pop();
      }
    });

    return Layout(
      timer: SizedBox(
        width: 320,
        height: 320,
        child: Stack(fit: StackFit.expand, children: [
          //Progress
          _CircularProgress(progress: elapsedTime.isNaN ? 0 : elapsedTime),

          //Display
          Center(child: TimerDisplay(seconds: timerState.seconds)),
        ]),
      ),
      button: const _ControlButtons(),
    );
  }
}

//Progress
class _CircularProgress extends ConsumerWidget {
  const _CircularProgress({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Transform.rotate(
      angle: -math.pi / 2, // 반시계 방향으로 90도 회전
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: progress,
          hideHandler: true,
        ),
      ),
    );
  }
}

//Button
class _ControlButtons extends ConsumerWidget {
  const _ControlButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimerButton(
          onPressed: () => ref.read(timerProvider.notifier).cancel(),
          isSecondary: true,
          child: const Text('취소'),
        ),
        const SizedBox(width: 40),
        if (!timerState.isPaused)
          TimerButton(
            onPressed: () => ref.read(timerProvider.notifier).pause(),
            isSecondary: true,
            isDestructiveAction: true,
            child: const Text('일시정지'),
          )
        else
          TimerButton(
            onPressed: () => ref.read(timerProvider.notifier).restart(),
            child: const Text('계속'),
          )
      ],
    );
  }
}
