import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:videocall/controllers/user_controller.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/models/user.dart';
import 'package:videocall/pages/first_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>>? futureUsers;
  final userDB = UserDB();

  // ignore: non_constant_identifier_names
  ButtonStyle CustomButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(const Size(300, 58)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
                side: const BorderSide(color: Colors.white))));
  }

  late final UserController _userController;
  @override
  void initState() {
    super.initState();
    _userController = UserController();
    setState(() {
      userDB.create(
          user: User(
              name: "phung dai dong",
              phone: "0368728267",
              password: "123",
              image: "dong.png",
              isUsing: true));
      futureUsers = userDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-begin.png'),
              fit: BoxFit.cover)),
      padding: const EdgeInsets.all(0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: 1000,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Home',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text('Start with sign in or sign up',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(160),
            ),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final users = snapshot.data!;
                    if (users.isNotEmpty) {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Column(
                              children: [
                                Text(user.id!.toString()),
                                Text(user.name),
                                Text(user.phone),
                                Text(user.image),
                                Text(user.password),
                                Text(user.isUsing.toString()),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12);
                          },
                          itemCount: users.length);
                    } else {
                      return const Text('hello');
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FirstPage()));
                      },
                      style: CustomButtonStyle(),
                      child: const Text(
                        'First page',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
