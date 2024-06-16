import 'package:flutter/material.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/pages/signup_page2.dart';
import './signin_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 5, 30, 66), Colors.blue.shade700],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight),
          ),
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
                          'Get Started',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text('Start with sign in or sign up',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(160),
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
                                    builder: (context) => const SignInPage()));
                          },
                          style: Common.customButtonStyle(
                              backgroundColorHover:
                                  const Color.fromARGB(255, 91, 198, 251),
                              textColorHover:
                                  const Color.fromARGB(255, 6, 45, 102),
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              circular: 4,
                              size: const Size(290, 50),
                              boderSideColor:
                                  const Color.fromARGB(255, 91, 198, 251)),
                          child: const Text('Sign in'),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp2Page()));
                          },
                          style: Common.customButtonStyle(
                              backgroundColorHover:
                                  const Color.fromARGB(255, 91, 198, 251),
                              textColorHover:
                                  const Color.fromARGB(255, 6, 45, 102),
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              circular: 4,
                              size: const Size(290, 50),
                              boderSideColor:
                                  const Color.fromARGB(255, 91, 198, 251)),
                          child: const Text('Sign up'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
