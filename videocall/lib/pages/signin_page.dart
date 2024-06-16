import 'package:flutter/material.dart';
import 'package:videocall/database/auth.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/pages/forgot_password.dart';
import 'package:videocall/pages/home_page.dart';
import 'package:videocall/database/user_db.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isHidePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  final _phoneController = TextEditingController(text: '0368728267');
  final _passwordController = TextEditingController(text: '123456');
  final _userDB = UserDB(); // Database helper
  final _authDB = AuthDB();

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
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text('How\'s it going!',
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
                          cursorColor: Colors.white,
                          cursorErrorColor: Colors.white,
                          cursorHeight: 25,
                          controller: _phoneController,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: Common.customDecoration(
                              labelText: 'Phone number',
                              prefixIcon: Icons.phone),
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
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        TextFormField(
                          cursorColor: Colors.white,
                          cursorErrorColor: Colors.white,
                          cursorHeight: 25,
                          controller: _passwordController,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          obscureText: _isHidePassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.6,
                              ),
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                            // labelStyle: const TextStyle(color: Colors.black),
                            errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade100),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              color: Colors.white,
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
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.6,
                              ),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.6,
                              ),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.6,
                              ),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.6, color: Colors.white),
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
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          style: ButtonStyle(
                            animationDuration: const Duration(microseconds: 1),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue;
                                }
                                return Colors.white;
                              },
                            ),
                            overlayColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                decorationColor: Colors.white,
                                decoration: TextDecoration.underline,
                                color: Colors.white),
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
                            style: Common.customButtonStyle(
                                backgroundColorHover:
                                    const Color.fromARGB(255, 91, 198, 251),
                                textColorHover:
                                    const Color.fromARGB(255, 6, 45, 102),
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                circular: 4,
                                size: const Size(280, 50),
                                boderSideColor:
                                    const Color.fromARGB(255, 91, 198, 251)),
                            child: const Text('Login'),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: Common.customButtonStyle(
                                backgroundColorHover:
                                    const Color.fromARGB(255, 91, 198, 251),
                                textColorHover:
                                    const Color.fromARGB(255, 6, 45, 102),
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                circular: 4,
                                size: const Size(280, 50),
                                boderSideColor:
                                    const Color.fromARGB(255, 91, 198, 251)),
                            child: const Text(
                              'Back to previous',
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
        ),
        if (_isLoading) Common.circularProgress()
      ],
    );
  }

  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text;
      final password = _passwordController.text;

      setState(() {
        // _isLoading = true;
        _authDB.logIn(phone, password, 500).then((value) {
          // _isLoading = false;
          if (mounted) {
            // Check if the widget is still mounted
            if (value) {
              // Login successful, navigate to home page
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            } else {
              Common.customScaffoldMessager(
                  context: context,
                  message: 'Invalid phone number or password!',
                  duration: const Duration(milliseconds: 2000));
            }
          }
        });
      });
    }
  }
}
