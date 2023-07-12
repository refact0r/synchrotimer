import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../helpers/utils.dart';
import 'drawer.dart';

class HybridsPage extends StatefulWidget {
  const HybridsPage({super.key});

  @override
  State<HybridsPage> createState() => _HybridsPageState();
}

class _HybridsPageState extends State<HybridsPage> {
  final stopwatch = Stopwatch();
  int current = -1;
  bool running = false;
  List<double> fontSizes = [];
  List<String> timeStrings = [];
  List<Duration> startTimes = [];

  late final Ticker ticker = Ticker((tickerElapsed) {
    setState(() {
      timeStrings[current] = timeStringSec(stopwatch.elapsed - startTimes[current]);
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

  void start() {
    if (running) {
      setState(() {
        stopwatch.stop();
        ticker.stop();
        fontSizes[current] = 24;
        running = false;
      });
    } else {
      setState(() {
        stopwatch.start();
        timeStrings.add(timeStringSec(Duration.zero));
        fontSizes.add(32);
        startTimes.add(stopwatch.elapsed);
        current++;
        ticker.start();
        running = true;
      });
    }
  }

  void reset() {
    setState(() {
      stopwatch.reset();
      ticker.stop();
      timeStrings = [];
      fontSizes = [];
      startTimes = [];
      current = -1;
      running = false;
    });
  }

  Color startColor(ColorScheme colors) {
    if (running) {
      return colors.errorContainer;
    } else {
      return colors.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hybrids Timer",
          style: text.headlineSmall,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                HapticFeedback.selectionClick();
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const <Widget>[],
      ),
      drawer: const Drawer(
        child: NavigationDrawerWidget(selected: 1),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                itemCount: timeStrings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "# ${index + 1}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: text.displayLarge!.copyWith(
                              color: colors.secondary,
                              fontSize: fontSizes[index],
                              fontFeatures: const [FontFeature.tabularFigures()],
                              fontVariations: const [FontVariation('wght', 300)],
                            ),
                            child: Text(timeStrings[index]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Add a large start/stop elevatedbutton in the middle and a reset button next to it
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    backgroundColor: colors.secondaryContainer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 28,
                    color: colors.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: start,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      backgroundColor: running ? colors.errorContainer : colors.primaryContainer,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    child: Text(
                      running ? "Stop" : "Start",
                      style: TextStyle(
                        fontSize: 24,
                        color: running ? colors.error : colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
