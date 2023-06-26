import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/history.dart';

class HistoryPage extends StatefulWidget {
  final History prefs;

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
                _showDialog();
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

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          content: const Text(
            'Clear history?',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  widget.prefs.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
