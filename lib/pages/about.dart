import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = "";

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = "${info.version} (${info.buildNumber})";
    });
  }

  Future<void> url(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: BackButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, null);
          },
        ),
        actions: <Widget>[],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Synchrotimer',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Version $version',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            const Text(
              'Created by refact0r',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    url('https://github.com/refact0r/synchrotimer');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    "Github",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    url('https://github.com/refact0r/synchrotimer/blob/master/PRIVACY-POLICY.md');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    "Privacy Policy",
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
