import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/info.dart';
import '../helpers/utils.dart';

class GroupPage extends StatefulWidget {
  final int eventIndex;

  const GroupPage({Key? key, required this.eventIndex}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
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
        title: const Text('Select Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                eventNames[widget.eventIndex],
                style: const TextStyle(fontSize: 20),
              ),
            ),
            for (int i = 0; i < groupNames.length; i++)
              if (timeLimits[widget.eventIndex][i] != 0)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    key: ValueKey(groupNames[i]),
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
                          groupNames[i],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          timeStringShort(timeLimits[widget.eventIndex][i]),
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
