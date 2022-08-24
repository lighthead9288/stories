import 'dart:async';

import 'package:flutter/widgets.dart';

class PercentNotifier extends ValueNotifier<double> {
  final Future<void> Function() onNext;

  static const _singleStorySeconds = 7;
  late Timer _timer;

  PercentNotifier(double value, {required this.onNext}) : super(value) {
    timerStart();
  }

  @override
  void dispose() {
    super.dispose();
    timerStop();
  }

  void timerStart() {
    _timer = Timer.periodic(
      const Duration(
        // 70 ms - 7 seconds divided on 100 equal time periods
        milliseconds: _singleStorySeconds * 10), 
        (_) {
          if (value < 1) {
            value += 0.01;
          } else {
            _timer.cancel();
            onNext();
          }
        }
    );
  }

  void timerStop() {
    _timer.cancel();
  }

  void timerRestart() {
    value = 0;
    _timer.cancel();
    timerStart();
  }
  
  double getStoryLoadingPercent(
    int timeSegmentNumber, 
    double percent, 
    int curPageNumber
  ) {
    // 1. 100 % filling for previous pages,
    // 2. current percent value for current selected page
    // 3. 0 % filling for next pages
    return (timeSegmentNumber < curPageNumber)
        ? 1
        : (timeSegmentNumber > curPageNumber)
            ? 0
            : percent;
  }
}
