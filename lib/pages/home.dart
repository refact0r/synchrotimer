import 'dart:core';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> fontSizes = [68, 48, 48];
  List<String> timeStrings = ["00:00.00", "00:00.00", "00:00.00"];
  List<Duration> finalTimeValues = [Duration.zero, Duration.zero, Duration.zero];
  Duration elapsed = Duration.zero;
  int stopwatchState = 0;
  final stopwatch = Stopwatch();
  late final Ticker ticker = Ticker((tickerElapsed) {
    setState(() {
      elapsed = tickerElapsed;
      if (stopwatchState == 0) {
      } else if (stopwatchState == 1) {
        timeStrings[0] = getTimeString(stopwatch.elapsed);
      } else if (stopwatchState == 2) {
        timeStrings[1] = getTimeString(stopwatch.elapsed - finalTimeValues[0]);
        timeStrings[2] = getTimeString(stopwatch.elapsed - finalTimeValues[0]);
      } else if (stopwatchState == 3) {
        timeStrings[2] = getTimeString(stopwatch.elapsed - finalTimeValues[0]);
      }
    });
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  String getTimeString(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds = (duration.inMilliseconds % 1000 / 10).floor().toString().padLeft(2, '0');
    return "$minutes:$seconds.$milliseconds";
  }

  void changeStopwatchState() {
    setState(() {
      if (stopwatchState == 0) {
        stopwatch.start();
        ticker.start();
        timeStrings = ["00:00.00", "00:00.00", "00:00.00"];
        stopwatchState = 1;
        fontSizes = [68, 48, 48];
      } else if (stopwatchState == 1) {
        finalTimeValues[0] = stopwatch.elapsed;
        stopwatchState = 2;
        timeStrings[0] = getTimeString(finalTimeValues[0]);
        fontSizes = [48, 68, 48];
      } else if (stopwatchState == 2) {
        finalTimeValues[1] = stopwatch.elapsed - finalTimeValues[0];
        stopwatchState = 3;
        timeStrings[1] = getTimeString(finalTimeValues[1]);
        fontSizes = [48, 48, 68];
      } else if (stopwatchState == 3) {
        stopwatch.stop();
        finalTimeValues[2] = stopwatch.elapsed - finalTimeValues[0];
        ticker.stop();
        timeStrings[2] = getTimeString(finalTimeValues[2]);
        stopwatch.reset();
        stopwatchState = 0;
        print(finalTimeValues);
      }
    });
  }

  String getButtonLabel() {
    if (stopwatchState == 0) {
      return "Start Walk Time";
    } else if (stopwatchState == 1) {
      return "Start Deck Time";
    } else if (stopwatchState == 2) {
      return "Start Routine Time";
    } else if (stopwatchState == 3) {
      return "Stop";
    } else {
      return "Error";
    }
  }

  Color getButtonColor(ColorScheme colorScheme) {
    if (stopwatchState == 0) {
      return colorScheme.primaryContainer;
    } else if (stopwatchState == 1) {
      return colorScheme.tertiaryContainer;
    } else if (stopwatchState == 2) {
      return colorScheme.tertiaryContainer;
    } else if (stopwatchState == 3) {
      return colorScheme.errorContainer;
    } else {
      return colorScheme.errorContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Synchrotimer",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Walk Time",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: fontSizes[0],
                    fontFeatures: <FontFeature>[
                      const FontFeature.tabularFigures(),
                    ],
                  ),
                  child: Text(timeStrings[0]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Deck Time",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: fontSizes[1],
                    fontFeatures: <FontFeature>[
                      const FontFeature.tabularFigures(),
                    ],
                  ),
                  child: Text(timeStrings[1]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Total Routine Time",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: fontSizes[2],
                    fontFeatures: <FontFeature>[
                      const FontFeature.tabularFigures(),
                    ],
                  ),
                  child: Text(timeStrings[2]),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: changeStopwatchState,
                style: ElevatedButton.styleFrom(
                  backgroundColor: getButtonColor(Theme.of(context).colorScheme),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                ),
                child: Text(
                  getButtonLabel(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
