import 'package:flutter/material.dart';
import 'package:videocall/helpers/ui_common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonalPage(),
    );
  }
}

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
      backgroundColor: Colors.blue[700],
      title: const Text('Change personal information'),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  SafeArea _body() {
    return SafeArea(
        child: Center(
      child: Column(children: [UICommon.linearProgress()]),
    ));
  }
}
