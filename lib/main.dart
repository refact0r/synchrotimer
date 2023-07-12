import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'pages/home.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'synchrotimer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue.shade800,
        brightness: Brightness.light,
        fontFamily: 'Plus Jakarta Sans',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
