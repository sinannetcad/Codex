import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/dating_api.dart';

void main() {
  runApp(const TinderCloneApp());
}

class TinderCloneApp extends StatelessWidget {
  const TinderCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:5000',
    );

    return MaterialApp(
      title: 'Tinder Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: HomeScreen(
        api: DatingApi(baseUrl: apiBaseUrl),
      ),
    );
  }
}
