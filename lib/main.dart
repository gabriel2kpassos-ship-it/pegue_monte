import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'modules/dashboard/dashboard_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PegueMonteApp());
}

class PegueMonteApp extends StatelessWidget {
  const PegueMonteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pegue & Monte',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const DashboardPage(),
    );
  }
}
