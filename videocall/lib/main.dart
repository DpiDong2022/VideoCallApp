import 'package:flutter/material.dart';
import 'package:videocall/helpers/ref.dart';
import 'pages/first_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if userId exists
  bool isLoggedIn = await checkUserLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkUserLoggedIn() async {
  // Check for existing userId in SharedPreferences
  bool hasUserId = await SharedPreferencesHelper.containsKey('userId');
  return hasUserId;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Determine the home page based on whether the user is logged in
      home: isLoggedIn ? const HomePage() : const FirstPage(),
    );
  }
}
