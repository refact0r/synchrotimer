import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synchrotimer/pages/home.dart';

import 'about.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key, required this.selected}) : super(key: key);

  final int selected;

  final List<Widget> pages = const [
    HomePage(),
    AboutPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selected,
      onDestinationSelected: (index) {
        HapticFeedback.selectionClick();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => pages[index],
          ),
        );
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Text(
            "Synchrotimer",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.timer_outlined),
          selectedIcon: const Icon(Icons.timer),
          label: Text(
            "Routine Timer",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.list_alt_outlined),
          selectedIcon: const Icon(Icons.list_alt),
          label: Text(
            "Hybrids Timer",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.info_outline),
          selectedIcon: const Icon(Icons.info),
          label: Text(
            "About",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
