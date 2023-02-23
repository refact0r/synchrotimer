import 'dart:core';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:synchrotimer/pages/event.dart';

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
  bool deckLimitExceeded = false;
  bool routineLimitExceeded = false;
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
      if (stopwatchState == 2 && (stopwatch.elapsed - finalTimeValues[0]) > const Duration(seconds: 10)) {
        deckLimitExceeded = true;
      }
      if ((stopwatch.elapsed - finalTimeValues[0]) > Duration(seconds: timeLimit + 5)) {
        routineLimitExceeded = true;
      }
    });
  });
  String eventString = "12 & Under Solo";
  int timeLimit = 120;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  String getButtonLabel() {
    final List<String> buttonLabels = ["Start Walk Time", "Start Deck Time", "Start Routine Time", "Stop"];
    return buttonLabels[stopwatchState];
  }

  Color getButtonColor(ColorScheme colorScheme) {
    final List<Color> buttonColors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
      colorScheme.errorContainer
    ];
    return buttonColors[stopwatchState];
  }

  Color getButtonTextColor(ColorScheme colorScheme) {
    final List<Color> buttonTextColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error
    ];
    return buttonTextColors[stopwatchState];
  }

  String getTimeString(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds = (duration.inMilliseconds % 1000 / 10).floor().toString().padLeft(2, '0');
    return "$minutes:$seconds.$milliseconds";
  }

  String getTimeLimitString(int duration) {
    String minutes = (duration / 60 % 60).floor().toString();
    String seconds = (duration % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void changeStopwatchState() {
    setState(() {
      if (stopwatchState == 0) {
        stopwatch.start();
        timeStrings = ["00:00.00", "00:00.00", "00:00.00"];
        stopwatchState = 1;
        deckLimitExceeded = false;
        routineLimitExceeded = false;
        ticker.start();
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
        if (finalTimeValues[1] > const Duration(seconds: 10)) {
          deckLimitExceeded = true;
        }
        fontSizes = [48, 48, 68];
      } else if (stopwatchState == 3) {
        stopwatch.stop();
        finalTimeValues[2] = stopwatch.elapsed - finalTimeValues[0];
        ticker.stop();
        timeStrings[2] = getTimeString(finalTimeValues[2]);
        if (finalTimeValues[2] > Duration(seconds: timeLimit + 5) ||
            finalTimeValues[2] < Duration(seconds: timeLimit - 5)) {
          routineLimitExceeded = true;
        }
        stopwatch.reset();
        stopwatchState = 0;
      }
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Synchrotimer",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Walk Time",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: fontSizes[0],
                    fontFeatures: [const FontFeature.tabularFigures()],
                    fontVariations: const [FontVariation('wght', 300)],
                  ),
                  child: Text(timeStrings[0]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    "Deck Time < 0:10",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: deckLimitExceeded
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.secondary,
                    fontSize: fontSizes[1],
                    fontFeatures: [const FontFeature.tabularFigures()],
                    fontVariations: const [FontVariation('wght', 300)],
                  ),
                  child: Text(timeStrings[1]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                  child: Text(
                    "Total Routine Time - ${getTimeLimitString(timeLimit)} ± 5",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: routineLimitExceeded
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary,
                    fontSize: fontSizes[2],
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontVariations: const [FontVariation('wght', 300)],
                  ),
                  child: Text(timeStrings[2]),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventPage(),
                  ),
                ).then(
                  (result) => {
                    if (result != null)
                      {
                        setState(() {
                          timeLimit = result[0];
                          eventString = result[1];
                        })
                      }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
              child: Text(
                eventString,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: changeStopwatchState,
                style: ElevatedButton.styleFrom(
                  backgroundColor: getButtonColor(Theme.of(context).colorScheme),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                child: Text(
                  getButtonLabel(),
                  style: TextStyle(
                    color: getButtonTextColor(Theme.of(context).colorScheme),
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
