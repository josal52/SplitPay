import 'package:splitpay/views/end_view.dart';
import 'package:splitpay/views/split_view.dart';
import 'views/start_view.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        '/split': (context) => SplitView(),
        '/end': (context) => EndView()
      },
    );
  }
}
