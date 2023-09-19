import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_timer/providers/selected_duration.dart';

final class TimerState extends Equatable {
  const TimerState({
    this.isRunning = false,
    this.isPaused = true,
    this.seconds = 0,
    this.initialSeconds = 0,
  });

  // * 작동 여부
  final bool isRunning;

  // * 종료 여부
  final bool isPaused;

  // * 종료까지 남은 시간
  final int seconds;

  // * 처음에 설정한 시간
  final int initialSeconds;

  TimerState copyWith({
    final bool? isRunning,
    final bool? isPaused,
    final int? seconds,
    final int? initialSeconds,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      seconds: seconds ?? this.seconds,
      initialSeconds: initialSeconds ?? this.initialSeconds,
    );
  }

  @override
  List<Object?> get props => [
        isRunning,
        isPaused,
        seconds,
        initialSeconds,
      ];
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({required this.totalSeconds}) : super(const TimerState()) {
    state = state.copyWith(
      isRunning: true,
      isPaused: false,
      seconds: totalSeconds,
      initialSeconds: totalSeconds,
    );

    start();
  }

  final int totalSeconds;
  late StreamSubscription<int> _stream;

  void start() {
    const duration = Duration(seconds: 1);
    _stream = Stream.periodic(duration, (_) {
      if (state.seconds > 0) {
        return state.seconds - 1;
      } else {
        return state.seconds;
      }
    }).listen((t) {
      if (!mounted) return;
      if (t == 0) cancel();
      state = state.copyWith(seconds: t);
    });
  }

  void cancel() {
    _stream.cancel();
    state = state.copyWith(
      isRunning: false,
      isPaused: true,
      seconds: 0,
      initialSeconds: 0,
    );
  }

  void pause() {
    _stream.pause();
    state = state.copyWith(isPaused: true);
  }

  void restart() {
    _stream.resume();
    state = state.copyWith(isPaused: false);
  }
}

final timerProvider =
    StateNotifierProvider.autoDispose<TimerNotifier, TimerState>((ref) {
  final selectedSeconds = ref.watch(selectedSecondsProvider);
  final isSeconds = ref.watch(isSecondsProvider);

  final totalSeconds = isSeconds ? selectedSeconds : selectedSeconds * 60;

  return TimerNotifier(totalSeconds: totalSeconds);
});
