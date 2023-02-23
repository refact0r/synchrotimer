import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final List<String> groupNames = [
    'SR/JR/JO Free & Collegiate',
    'SR/JR/JO Tech',
    'Youth Free',
    '12 & Under',
    'Intermediate',
    'Novice',
    'Masters Free',
    'Masters Tech'
  ];
  final List<String> eventNames = [
    'Solo',
    'Mixed Duet',
    'Duet/Trio',
    'Team',
    'Combination',
    'Acrobatic',
  ];
  List<List<int>> times = [
    [135, 120, 120, 120, 105, 90, 150, 90],
    [165, 140, 150, 150, 125, 90, 180, 100],
    [165, 140, 150, 150, 125, 90, 180, 100],
    [210, 170, 180, 180, 155, 90, 240, 110],
    [210, 0, 180, 180, 180, 0, 240, 0],
    [180, 0, 0, 0, 0, 0, 0, 0]
  ];
  bool firstPage = true;
  int groupIndex = 0;
  int eventIndex = 0;

  void select(int index) {
    setState(() {
      if (firstPage) {
        groupIndex = index;
        firstPage = false;
      } else {
        eventIndex = index;
        Navigator.pop(context, [times[eventIndex][groupIndex], '${groupNames[groupIndex]} ${eventNames[eventIndex]}']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (!firstPage) {
                firstPage = true;
              } else {
                Navigator.pop(context, null);
              }
            });
          },
        ),
        title: Text(firstPage ? 'Select Group' : 'Select Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
        child: getOptions(),
      ),
    );
  }

  Widget getOptions() {
    List<String> currentList = firstPage ? groupNames : eventNames;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!firstPage)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              groupNames[groupIndex],
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        for (int i = 0; i < currentList.length; i++)
          if (firstPage || (!firstPage && times[i][groupIndex] != 0))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                key: ValueKey(currentList[i]),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  select(i);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                child: Text(
                  currentList[i],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
      ],
    );
  }
}
