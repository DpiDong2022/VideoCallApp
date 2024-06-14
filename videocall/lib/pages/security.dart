import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'dart:io';

import 'package:videocall/helpers/common.dart';
import 'package:videocall/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SecurityPage(),
    );
  }
}

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
      ),
      backgroundColor: Colors.blue[700],
      title: const Text('Security'),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('This is security pages')],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _appBar(),
          body: _body(),
        )
      ],
    );
  }
}
