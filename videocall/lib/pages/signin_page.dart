import 'package:flutter/material.dart';
import 'package:videocall/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isHidePassword = true;
  ButtonStyle customButtonStyle() {
    return ButtonStyle(
        // backgroundColor: MaterialStateProperty.all(Colors.white),
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
                      'Welcome Back',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text('How\'s it going bro',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            Container(
              width: 1000,
              height: 300,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 20, height: 0.8),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your phone number',
                        prefixIcon: Icon(Icons.phone),
                        focusedBorder: UnderlineInputBorder(),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 0, 0),
                              width: 2.0), // Border when focused and error
                        ),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.6))),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != 10) {
                          return 'Số điện thoại có chiều dài là 10!';
                        } else {
                          return null;
                        }
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  TextFormField(
                    style: const TextStyle(fontSize: 20, height: 0.8),
                    obscureText: _isHidePassword,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _isHidePassword = !_isHidePassword;
                              });
                            },
                            icon: Icon(_isHidePassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye)),
                        focusedBorder: const UnderlineInputBorder(),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0), // Border when focused and error
                        ),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.6))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors
                                .white; // Change text color when pressed
                          }
                          return Colors.black; // Default text color
                        },
                      ),
                      // Remove any overlay color, which is typically used for ripple effects
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: const Text('Forgot password?',
                        style: TextStyle(decoration: TextDecoration.underline)),
                  )
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        style: customButtonStyle(),
                        child: const Text(
                          'Sign in',
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
