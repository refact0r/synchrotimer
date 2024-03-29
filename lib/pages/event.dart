import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/info.dart';
import '../helpers/utils.dart';

class EventPage extends StatefulWidget {
  final int groupIndex;

  const EventPage({Key? key, required this.groupIndex}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            setState(() {
              Navigator.pop(context, null);
            });
          },
        ),
        title: const Text('Select Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                groupNames[widget.groupIndex],
                style: const TextStyle(fontSize: 20),
              ),
            ),
            for (int i = 0; i < eventNames.length; i++)
              if (timeLimits[i][widget.groupIndex] != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    key: ValueKey(eventNames[i]),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context, i);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          eventNames[i],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          timeStringShort(timeLimits[i][widget.groupIndex]),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
