import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: _body(),
        bottomNavigationBar: _bottomNavigation());
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blue[700],
      title: TextFormField(
        cursorColor: const Color.fromARGB(255, 17, 172, 255),
        cursorHeight: 25,
        cursorRadius: const Radius.circular(50),
        mouseCursor: MouseCursor.defer,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
            focusColor: Colors.black,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            hintText: "Search...",
            hintStyle:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.normal),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            suffixIcon: Icon(Icons.close)),
        onChanged: (value) {},
      ),
      titleTextStyle: const TextStyle(color: Colors.white),
    );
  }

  BottomNavigationBar _bottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.blue[700],
      currentIndex: _bottomItemIndex,
      unselectedItemColor: Colors.white60,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      onTap: (index) {
        setState(() {
          _bottomItemIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.group_add,
            ),
            label: "Add"),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline_sharp,
          ),
          label: "Me",
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_sharp,
            ),
            label: "Me"),
      ],
    );
  }

  SafeArea _body() {
    return const SafeArea(
      child: Center(
        child: Text('Welcome to the Video Call App!'),
      ),
    );
  }
}
