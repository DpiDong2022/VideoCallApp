import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/data_center.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isHidePassword = true;
  ButtonStyle CustomButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(Size(300, 58)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
                side: BorderSide(color: Colors.white))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-begin.png'),
              fit: BoxFit.cover)),
      padding: EdgeInsets.all(0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              new Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
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
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Your phone number',
                          prefixIcon: const Icon(Icons.phone)),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    TextFormField(
                        obscureText: _isHidePassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.vpn_key),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isHidePassword = !_isHidePassword;
                                  });
                                },
                                icon: Icon(_isHidePassword
                                    ? Icons.visibility_off
                                    : Icons.remove_red_eye)))),
                  ],
                ),
              ),
              new Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        style: CustomButtonStyle(),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back to previous',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        style: CustomButtonStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
