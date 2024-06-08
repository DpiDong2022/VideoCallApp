import 'package:flutter/material.dart';
import 'package:videocall/pages/forgot_password.dart';
import 'package:videocall/pages/home_page.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/models/user.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isHidePassword = true;
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userDB = UserDB(); // Database helper

  ButtonStyle customButtonStyle() {
    return ButtonStyle(
      fixedSize: MaterialStateProperty.all(const Size(300, 58)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
          side: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-begin.png'),
          fit: BoxFit.cover,
        ),
      ),
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(fontSize: 20, height: 0.8),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your phone number',
                        prefixIcon: Icon(Icons.phone),
                        focusedBorder: UnderlineInputBorder(),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.6),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits long';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    TextFormField(
                      controller: _passwordController,
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
                          icon: Icon(
                            _isHidePassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 0.6),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 5) {
                          return 'Password must be at least 5 characters long';
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Colors.black;
                          },
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _signIn, // Handle sign-in logic
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
                      ),
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

  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text;
      final password = _passwordController.text;

      final user = await _userDB.fetchByPhoneAndPassword(phone, password);

      if (mounted) {
        // Check if the widget is still mounted
        if (user != null) {
          // Login successful, navigate to home page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid phone number or password')),
          );
        }
      }
    }
  }
}
