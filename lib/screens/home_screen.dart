import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minimal_timer/configs/assets.dart';
import 'package:minimal_timer/providers/selected_duration.dart';
import 'package:minimal_timer/screens/timer_screen.dart';
import 'package:minimal_timer/widgets/circular_progress_painter.dart';
import 'package:minimal_timer/widgets/layout.dart';
import 'package:minimal_timer/widgets/timer_button.dart';
import 'package:minimal_timer/widgets/timer_display.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDuration = ref.watch(selectedDurationProvider);
    final selectedSeconds = ref.watch(selectedSecondsProvider);

    return WillPopScope(
      onWillPop: () => _handleBackPressed(context),
      child: Layout(
        timer: SizedBox(
          width: 320,
          height: 320,
          child: Stack(fit: StackFit.expand, children: [
            //Slider
            _CircularSlider(progress: selectedDuration),

            //Display
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: _TimeUnitSwitch.height),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TimerDisplay(seconds: selectedSeconds),
                ),
                const _TimeUnitSwitch(),
              ],
            ),
          ]),
        ),
        button: const _StartButton(),
      ),
    );
  }

  Future<bool> _handleBackPressed(BuildContext context) async {
    final exitConfirmed = await showDialog<bool>(
      context: context,
      // builder: (ctx) => const AdNativeBanner(),
      builder: (ctx) => Column(children: [
        Container(
          color: Colors.red,
          width: 500,
          height: 400,
        ),
        Row(children: [
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('종료'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
        ]),
      ]),
    );

    return exitConfirmed ?? false;
  }
}

//Slider
class _CircularSlider extends ConsumerWidget {
  const _CircularSlider({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Transform.rotate(
      angle: -math.pi / 2, // 반시계 방향으로 90도 회전
      child: GestureDetector(
        onPanUpdate: (details) {
          // * `CircularSlider` 위젯의 중심 좌표를 가져와요.
          final renderBox = context.findRenderObject() as RenderBox;
          final center = renderBox.size.center(Offset.zero);

          // * 사용자 터치 좌표 - 중심 좌표
          final touchVector = details.localPosition - center;

          // * 벡터의 각도를 계산해요.
          final angle = math.atan2(touchVector.dy, touchVector.dx);

          // * 원주율을 0.0 ~ 1.0 범위로 한정하고, 60진법으로 조정해요.
          final progress = (angle / (2 * math.pi)) % 1.0;
          final adjustedProgress = (progress * 60).round() / 60;

          ref //event
              .read(selectedDurationProvider.notifier)
              .update((state) => adjustedProgress);
        },
        child: CustomPaint(
          painter: CircularProgressPainter(
            progress: progress,
          ),
        ),
      ),
    );
  }
}

//TimeUnitSwitch
class _TimeUnitSwitch extends ConsumerWidget {
  const _TimeUnitSwitch();

  static const double height = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSeconds = ref.watch(isSecondsProvider);
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () {
        ref.read(isSecondsProvider.notifier).update((state) => !state);
      },
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        visualDensity: VisualDensity.compact,
        fixedSize: const Size.fromHeight(height),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        //Icon
        SvgPicture.asset(
          Assets.arrowUpDown,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
          height: 16,
        ),

        const SizedBox(width: 4),

        // Title
        if (isSeconds) const Text('Seconds') else const Text('Minutes'),
      ]),
    );
  }
}

//Button
class _StartButton extends StatelessWidget {
  const _StartButton();

  Route _noneTransitionRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const TimerScreen(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimerButton(
      onPressed: () {
        Navigator.of(context).push(_noneTransitionRoute());
      },
      child: const Text('시작'),
    );
  }
}
