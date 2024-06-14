import 'package:flutter/material.dart';
import 'package:videocall/helpers/common.dart';
import './signin_page.dart';
import './signup_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // ignore: non_constant_identifier_names

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
                      'Get Started',
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
                      style: Common.customButtonStyle(),
                      child: const Text('Sign in'),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      style: Common.customButtonStyle(),
                      child: const Text('Sign up'),
                    )
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
