import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container(
      child: const Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
