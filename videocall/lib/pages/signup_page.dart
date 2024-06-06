import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ButtonStyle customButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(const Size(300, 58)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
                side: const BorderSide(color: Colors.white))));
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
        resizeToAvoidBottomInset: false,
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
                      'Sign your new account',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text('Welcome to master video call',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            Container(
              width: 1000,
              height: 200,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your phone number',
                        prefixIcon: Icon(Icons.phone)),
                  ),
                  // const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  // TextFormField(
                  //     obscureText: _isHidePassword,
                  //     decoration: InputDecoration(
                  //         border: const OutlineInputBorder(),
                  //         hintText: 'Password',
                  //         prefixIcon: const Icon(Icons.vpn_key),
                  //         suffixIcon: IconButton(
                  //             onPressed: () {
                  //               setState(() {
                  //                 _isHidePassword = !_isHidePassword;
                  //               });
                  //             },
                  //             icon: Icon(_isHidePassword
                  //                 ? Icons.visibility_off
                  //                 : Icons.remove_red_eye)))
                  //   ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              height: 100,
              child: const Row(
                children: [
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      fixedSize: MaterialStatePropertyAll(Size(20, 20)),
                    ),
                    onPressed: null,
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  Text(' -----> '),
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      fixedSize: MaterialStatePropertyAll(Size(20, 20)),
                    ),
                    onPressed: null,
                    child: Text('2'),
                  )),
                  Text(' -----> '),
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      fixedSize: MaterialStatePropertyAll(Size(20, 20)),
                    ),
                    onPressed: null,
                    child: Text('3'),
                  )),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: customButtonStyle(),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: customButtonStyle(),
                        child: const Text(
                          'Back to previous',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
