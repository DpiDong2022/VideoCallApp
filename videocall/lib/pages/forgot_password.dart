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
      Common.customScaffoldMessager(
          context: context,
          message: 'Code verified successfully.',
          duration: const Duration(seconds: 2));
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
              duration: const Duration(milliseconds: 2000));
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
          Common.customScaffoldMessager(
              context: context,
              message: 'Verification code sent to your phone.',
              duration: const Duration(milliseconds: 2000));
          _tabController.animateTo(1); // Move to the next tab
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          physics:
              const NeverScrollableScrollPhysics(), // Prevent swipe navigation
          children: [
            _buildPhoneNumberTab(),
            _buildVerificationCodeTab(),
            _buildNewPasswordTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers the Column's content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your phone number to reset your password:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 20, height: 0.8),
              focusNode: _phoneFocusNode, // Attach the FocusNode
              decoration: Common.customDecoration(
                  labelText: 'Phone number', prefixIcon: Icons.phone),
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            TextButton(
              onPressed: _validatePhoneNumber, // Handle sign-in logic
              style: Common.customButtonStyle(boderSideColor: Colors.black),
              child: const Text(
                'Send code',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCodeTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers the Column's content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter the verification code sent to your phone:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codeController,
              style: const TextStyle(fontSize: 20, height: 0.8),
              keyboardType: TextInputType.number,
              focusNode: _codeFocusNode, // Attach the FocusNode
              decoration: Common.customDecoration(
                  labelText: 'Verification Code',
                  prefixIcon: Icons.verified_user),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the verification code';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _verifyCode, // Handle sign-in logic
              style: Common.customButtonStyle(boderSideColor: Colors.black),
              child: const Text(
                'Verify Code',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers the Column's content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your new password:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(fontSize: 20, height: 0.8),
              controller: _passwordController,
              obscureText: _isHidePassword,
              focusNode: _passwordFocusNode, // Attach the FocusNode
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'New password',
                labelStyle: const TextStyle(color: Colors.black),
                errorStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red.shade600),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
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
                  return 'Please enter your new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _resetPassword, // Handle sign-in logic
              style: Common.customButtonStyle(boderSideColor: Colors.black),
              child: const Text(
                'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
