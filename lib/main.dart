import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:real_time_poll_app/screens/poll_list_screen.dart';
import 'package:real_time_poll_app/services/poll_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PollService>(create: (_) => PollService()),
      ],
      child: MaterialApp(
        title: 'Real-time Poll App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PollListScreen(),
      ),
    );
  }
}