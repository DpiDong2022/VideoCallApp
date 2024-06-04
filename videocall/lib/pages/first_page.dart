import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_center.dart';
import './signin_page.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
                        'Get Started',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
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
                padding: EdgeInsets.all(160),
              ),
              new Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        style: CustomButtonStyle(),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign up',
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
