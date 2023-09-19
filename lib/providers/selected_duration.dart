import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_timer/configs/constants.dart';

// 설정한 시간(초)을 0.00 ~ 1.00 범위로 정규화해요.
final selectedDurationProvider = StateProvider<double>((ref) {
  return initialSeconds / 60;
});

// 설정한 범위를 60진법으로 변환해요.
final selectedSecondsProvider = StateProvider<int>((ref) {
  final duration = ref.watch(selectedDurationProvider);
  return (duration * 60).toInt();
});

// seconds or minutes
final isSecondsProvider = StateProvider<bool>((ref) => true);
