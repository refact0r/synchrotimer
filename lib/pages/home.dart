import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchrotimer/pages/event.dart';

import '../helpers/history.dart';
import '../helpers/utils.dart';
import 'history.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> fontSizes = [72, 56, 56];
  List<String> timeStrings = [timeString(Duration.zero), timeString(Duration.zero), timeString(Duration.zero)];
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
        timeStrings[0] = timeString(stopwatch.elapsed);
      } else if (state == 3) {
        timeStrings[1] = timeString(stopwatch.elapsed - finalTimes[0]);
        timeStrings[2] = timeString(stopwatch.elapsed - finalTimes[0]);
      } else if (state == 4) {
        timeStrings[2] = timeString(stopwatch.elapsed - finalTimes[0]);
      }
      if (state == 3 && (stopwatch.elapsed - finalTimes[0]) > const Duration(seconds: 10)) {
        deckExceeded = true;
      }
      if ((stopwatch.elapsed - finalTimes[0]) > Duration(seconds: timeLimit + 5)) {
        routineExceeded = true;
      }
    });
  });
  String eventString = "12 & Under Solo";
  int timeLimit = 120;
  late SharedPreferences sharedPrefs;
  late History history;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void loadPrefs() async {
    sharedPrefs = await SharedPreferences.getInstance();
    history = History(sharedPrefs);
  }

  String getButtonLabel() {
    final List<String> buttonLabels = [
      "Start Walk Time",
      "Stop Walk Time",
      "Start Deck Time",
      "Start Routine Time",
      "Stop"
    ];
    return buttonLabels[state];
  }

  Color getButtonColor(ColorScheme colors) {
    final List<Color> buttonColors = [
      colors.primaryContainer,
      colors.errorContainer,
      colors.secondaryContainer,
      colors.tertiaryContainer,
      colors.errorContainer
    ];
    return buttonColors[state];
  }

  Color getButtonTextColor(ColorScheme colors) {
    final List<Color> buttonTextColors = [
      colors.primary,
      colors.error,
      colors.secondary,
      colors.tertiary,
      colors.error
    ];
    return buttonTextColors[state];
  }

  void changeStopwatchState() {
    setState(() {
      if (state == 0) {
        stopwatch.start();
        timeStrings = [timeString(Duration.zero), timeString(Duration.zero), timeString(Duration.zero)];
        state = 1;
        deckExceeded = false;
        routineExceeded = false;
        ticker.start();
        fontSizes = [72, 56, 56];
      } else if (state == 1) {
        stopwatch.stop();
        finalTimes[0] = stopwatch.elapsed;
        state = 2;
        timeStrings[0] = timeString(finalTimes[0]);
      } else if (state == 2) {
        stopwatch.start();
        state = 3;
        fontSizes = [56, 72, 56];
      } else if (state == 3) {
        finalTimes[1] = stopwatch.elapsed - finalTimes[0];
        state = 4;
        timeStrings[1] = timeString(finalTimes[1]);
        if (finalTimes[1] > const Duration(seconds: 10)) {
          deckExceeded = true;
        }
        fontSizes = [56, 56, 72];
      } else if (state == 4) {
        stopwatch.stop();
        finalTimes[2] = stopwatch.elapsed - finalTimes[0];
        ticker.stop();
        timeStrings[2] = timeString(finalTimes[2]);
        if (finalTimes[2] > Duration(seconds: timeLimit + 5) || finalTimes[2] < Duration(seconds: timeLimit - 5)) {
          routineExceeded = true;
        }
        stopwatch.reset();
        state = 0;
        history.add(timeStrings, eventString, deckExceeded, routineExceeded);
      }
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Synchrotimer",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() {
                ticker.stop();
                stopwatch.stop();
                stopwatch.reset();
                state = 0;
                timeStrings = [timeString(Duration.zero), timeString(Duration.zero), timeString(Duration.zero)];
                deckExceeded = false;
                routineExceeded = false;
                fontSizes = [72, 56, 56];
              });
            },
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
            tooltip: "Reset",
            icon: const Icon(Icons.restart_alt_rounded, size: 28),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage(prefs: history)),
              );
            },
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
            ),
            tooltip: "History",
            icon: const Icon(Icons.history_rounded, size: 28),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
              ),
              tooltip: "Info",
              icon: const Icon(Icons.info_outline_rounded, size: 28),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    "Total Routine Time - ${timeStringShort(timeLimit)} ± 5",
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
            const SizedBox(height: 24),
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
