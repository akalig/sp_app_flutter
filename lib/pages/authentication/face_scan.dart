import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaceScan extends StatefulWidget {
  const FaceScan({super.key});

  @override
  State<FaceScan> createState() => _FaceScanState();
}

class _FaceScanState extends State<FaceScan> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            // pageBuilder: (context, state) => NoTransitionPage(child: ),
          ),
        ],
      ),
    );
  }
}
