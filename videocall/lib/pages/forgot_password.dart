import 'package:flutter/material.dart';
import 'package:videocall/database/auth.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/common.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _userDB = UserDB();
  final _authDB = AuthDB();
  bool _isHidePassword = true;
  bool _isHidePassword2 = true;

  // FocusNodes for managing the focus state of the input fields
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Autofocus the first input field when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocusNode.requestFocus();
    });

    // Listen for tab changes to autofocus the respective input field
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _phoneFocusNode.requestFocus();
            });
            break;
          case 1:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _codeFocusNode.requestFocus();
            });
            break;
          case 2:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _passwordFocusNode.requestFocus();
            });
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _verifyCode() {
    // Simulate code verification
    if (_codeController.text.isNotEmpty) {
      _tabController.animateTo(2); // Move to the next tab
    } else {
      Common.customScaffoldMessager(
          context: context,
          message: 'Please enter the verification code.',
          duration: const Duration(milliseconds: 2000));
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate password reset
      var isSuccessed = await _authDB.changePassword(
          _phoneController.text.trim(), _passwordController.text.trim());
      if (mounted) {
        if (isSuccessed) {
          Common.customScaffoldMessager(
              context: context,
              message: 'Password has been reset.',
              duration: const Duration(milliseconds: 3000));
          Navigator.pop(context);
        } else {
          Common.customScaffoldMessager(
              context: context,
              message: 'Something went wrong! Software is updating...',
              duration: const Duration(milliseconds: 2000));
        }
      } // Go back to the previous screen
    }
  }

  void _validatePhoneNumber() async {
    if (_formKey.currentState?.validate() ?? false) {
      var user = await _userDB.fetchByPhone(_phoneController.text.trim());
      if (mounted) {
        if (user == null) {
          Common.customScaffoldMessager(
              context: context,
              message: 'Your phone number has not been registered yet.',
              duration: const Duration(milliseconds: 2000));
        } else {
          _tabController.animateTo(1); // Move to the next tab
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent swipe navigation
          children: [
            _buildPhoneNumberTab2(),
            _buildVerificationCodeTab2(),
            _buildNewPasswordTab2(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      shadowColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 3,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.blue.shade800),
      ),
      // title: const Text('Forgot password'),
      // titleTextStyle: TextStyle(color: Colors.blue.shade800, fontSize: 18),
    );
  }

  // Widget _buildPhoneNumberTab() {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min, // Centers the Column's content
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Text(
  //             'Enter your phone number to reset your password:',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           const SizedBox(height: 20),
  //           TextFormField(
  //             controller: _phoneController,
  //             keyboardType: TextInputType.phone,
  //             style: const TextStyle(fontSize: 20, height: 0.8),
  //             focusNode: _phoneFocusNode, // Attach the FocusNode
  //             decoration: Common.customDecoration(
  //                 labelText: 'Phone number', prefixIcon: Icons.phone),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter your phone number';
  //               }
  //               if (value.length != 10) {
  //                 return 'Phone number must be 10 digits';
  //               }
  //               return null;
  //             },
  //           ),
  //           const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
  //           TextButton(
  //             onPressed: _validatePhoneNumber, // Handle sign-in logic
  //             style: Common.customButtonStyle(boderSideColor: Colors.black),
  //             child: const Text(
  //               'Send code',
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPhoneNumberTab2() {
    return Container(
      color: const Color.fromARGB(255, 234, 252, 254).withOpacity(0.3),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reset your password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    const Text(
                      "Please enter your phone number",
                      style: TextStyle(
                          height: 2,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    SizedBox.fromSize(size: const Size(0, 15)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        cursorColor: Colors.blue.shade400,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
                        focusNode: _phoneFocusNode, // Attach the FocusNode
                        decoration:
                            Common.customDecoration2(labelText: 'Phone number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: _validatePhoneNumber,
                    style: Common.customButtonStyle(
                        backgroundColorHover:
                            const Color.fromARGB(255, 91, 198, 251),
                        textColorHover: const Color.fromARGB(255, 6, 45, 102),
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        circular: 4,
                        size: const Size(300, 50),
                        boderSideColor:
                            const Color.fromARGB(255, 91, 198, 251)),
                    child: const Text(
                      'Continue',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeTab2() {
    return Container(
      color: const Color.fromARGB(255, 234, 252, 254).withOpacity(0.3),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reset your password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    const Text(
                      "Please enter the verification number sent to your phone",
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    SizedBox.fromSize(size: const Size(0, 24)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        cursorColor: Colors.blue.shade400,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        controller: _codeController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
                        focusNode: _codeFocusNode, // Attach the FocusNode
                        decoration: Common.customDecoration2(
                            labelText: 'Verification Code'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the verification code';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: _verifyCode,
                    style: Common.customButtonStyle(
                        backgroundColorHover:
                            const Color.fromARGB(255, 91, 198, 251),
                        textColorHover: const Color.fromARGB(255, 6, 45, 102),
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        circular: 4,
                        size: const Size(300, 50),
                        boderSideColor:
                            const Color.fromARGB(255, 91, 198, 251)),
                    child: const Text(
                      'Continue',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildVerificationCodeTab() {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min, // Centers the Column's content
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Text(
  //             'Enter the verification code sent to your phone:',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           const SizedBox(height: 20),
  //           TextFormField(
  //             controller: _codeController,
  //             style: const TextStyle(fontSize: 20, height: 0.8),
  //             keyboardType: TextInputType.number,
  //             focusNode: _codeFocusNode, // Attach the FocusNode
  //             decoration: Common.customDecoration(
  //                 labelText: 'Verification Code',
  //                 prefixIcon: Icons.verified_user),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Please enter the verification code';
  //               }
  //               return null;
  //             },
  //           ),
  //           const SizedBox(height: 20),
  //           TextButton(
  //             onPressed: _verifyCode, // Handle sign-in logic
  //             style: Common.customButtonStyle(boderSideColor: Colors.black),
  //             child: const Text(
  //               'Verify Code',
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNewPasswordTab2() {
    return Container(
      color: const Color.fromARGB(255, 234, 252, 254).withOpacity(0.3),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reset your password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    const Text(
                      "Please enter your new password",
                      style: TextStyle(
                          height: 2,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.0000001),
                    ),
                    SizedBox.fromSize(size: const Size(0, 15)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        cursorColor: Colors.blue.shade400,
                        obscureText: _isHidePassword,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        controller: _passwordController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
                        focusNode: _passwordFocusNode,
                        decoration: Common.customDecoration2(
                            labelText: 'New password',
                            suffixIcon: IconButton(
                              color: Colors.blue.shade400,
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
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox.fromSize(size: const Size(0, 15)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        cursorColor: Colors.blue.shade400,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        keyboardType: TextInputType.phone,
                        obscureText: _isHidePassword2,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
                        decoration: Common.customDecoration2(
                            labelText: 'Confirm new password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isHidePassword2 = !_isHidePassword2;
                                  });
                                },
                                icon: Icon(_isHidePassword2
                                    ? Icons.visibility_off
                                    : Icons.remove_red_eye))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password again';
                          }
                          if (value != _passwordController.text.trim()) {
                            return 'Your new password does not match';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: _resetPassword,
                    style: Common.customButtonStyle(
                        backgroundColorHover:
                            const Color.fromARGB(255, 91, 198, 251),
                        textColorHover: const Color.fromARGB(255, 6, 45, 102),
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        circular: 4,
                        size: const Size(300, 50),
                        boderSideColor:
                            const Color.fromARGB(255, 91, 198, 251)),
                    child: const Text(
                      'Continue',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
