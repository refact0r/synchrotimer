import 'dart:core';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:synchrotimer/pages/event.dart';

import 'history.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> fontSizes = [68, 48, 48];
  List<String> timeStrings = ["00:00.00", "00:00.00", "00:00.00"];
  List<Duration> finalTimes = [Duration.zero, Duration.zero, Duration.zero];
  // Duration elapsed = Duration.zero;
  int state = 0;
  bool deckExceeded = false;
  bool routineExceeded = false;
  final stopwatch = Stopwatch();
  late final Ticker ticker = Ticker((tickerElapsed) {
    setState(() {
      // elapsed = tickerElapsed;
      if (state == 0) {
      } else if (state == 1) {
        timeStrings[0] = timeString(stopwatch.elapsed);
      } else if (state == 2) {
        timeStrings[1] = timeString(stopwatch.elapsed - finalTimes[0]);
        timeStrings[2] = timeString(stopwatch.elapsed - finalTimes[0]);
      } else if (state == 3) {
        timeStrings[2] = timeString(stopwatch.elapsed - finalTimes[0]);
      }
      if (state == 2 && (stopwatch.elapsed - finalTimes[0]) > const Duration(seconds: 10)) {
        deckExceeded = true;
      }
      if ((stopwatch.elapsed - finalTimes[0]) > Duration(seconds: timeLimit + 5)) {
        routineExceeded = true;
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
    return buttonLabels[state];
  }

  Color getButtonColor(ColorScheme colors) {
    final List<Color> buttonColors = [
      colors.primaryContainer,
      colors.secondaryContainer,
      colors.tertiaryContainer,
      colors.errorContainer
    ];
    return buttonColors[state];
  }

  Color getButtonTextColor(ColorScheme colors) {
    final List<Color> buttonTextColors = [colors.primary, colors.secondary, colors.tertiary, colors.error];
    return buttonTextColors[state];
  }

  String timeString(Duration duration) {
    String min = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String msec = (duration.inMilliseconds % 1000 / 10).floor().toString().padLeft(2, '0');
    return "$min:$sec.$msec";
  }

  String getTimeLimitString(int duration) {
    String min = (duration / 60 % 60).floor().toString();
    String sec = (duration % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  void changeStopwatchState() {
    setState(() {
      if (state == 0) {
        stopwatch.start();
        timeStrings = ["00:00.00", "00:00.00", "00:00.00"];
        state = 1;
        deckExceeded = false;
        routineExceeded = false;
        ticker.start();
        fontSizes = [68, 48, 48];
      } else if (state == 1) {
        finalTimes[0] = stopwatch.elapsed;
        state = 2;
        timeStrings[0] = timeString(finalTimes[0]);
        fontSizes = [48, 68, 48];
      } else if (state == 2) {
        finalTimes[1] = stopwatch.elapsed - finalTimes[0];
        state = 3;
        timeStrings[1] = timeString(finalTimes[1]);
        if (finalTimes[1] > const Duration(seconds: 10)) {
          deckExceeded = true;
        }
        fontSizes = [48, 48, 68];
      } else if (state == 3) {
        stopwatch.stop();
        finalTimes[2] = stopwatch.elapsed - finalTimes[0];
        ticker.stop();
        timeStrings[2] = timeString(finalTimes[2]);
        if (finalTimes[2] > Duration(seconds: timeLimit + 5) || finalTimes[2] < Duration(seconds: timeLimit - 5)) {
          routineExceeded = true;
        }
        stopwatch.reset();
        state = 0;
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.history),
              iconSize: 32,
            ),
          ),
        ],
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
                    color: deckExceeded ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
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
                    color:
                        routineExceeded ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.tertiary,
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
