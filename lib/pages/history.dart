import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/preferences.dart';
import '../helpers/utils.dart';

class HistoryPage extends StatefulWidget {
  final Preferences prefs;

  const HistoryPage({Key? key, required this.prefs}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        leading: BackButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, null);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  widget.prefs.clearHistory();
                });
              },
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
              ),
              tooltip: "Clear History",
              icon: const Icon(Icons.delete_outline_rounded, size: 28),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        children: <Widget>[
          for (List<Object> history in widget.prefs.history.reversed)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history[0] as String,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.2,
                          color: Theme.of(context).colorScheme.primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        history[1] as String,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.2,
                          color: history[4] as bool
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.secondary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        history[2] as String,
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.2,
                          color: history[5] as bool
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.tertiary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      history[3] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
