import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/ui_common.dart';
import 'package:videocall/models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _userDB = UserDB();
  File? _avatarImage;
  bool _isHidePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update the UI when the tab index changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      var user = await _userDB.fetchByPhone(_phoneController.text.trim());
      if (mounted) {
        if (user != null) {
          UICommon.customScaffoldMessager(
              context: context,
              message: 'Your phone number has been registered!',
              duration: const Duration(milliseconds: 2000));
        } else {
          UICommon.customScaffoldMessager(
              context: context,
              message: 'Verification code sent to your phone.',
              duration: const Duration(milliseconds: 2000));
          _tabController.animateTo(1); // Mo
        }
      }
    }
  }

  void _verifyCode(context) {
    if (_codeController.text.isNotEmpty) {
      UICommon.customScaffoldMessager(
          context: context,
          message: 'Code verified successfully.',
          duration: const Duration(milliseconds: 2000));
      _tabController.animateTo(2);
    } else {
      UICommon.customScaffoldMessager(
          context: context,
          message: 'Please enter the verification code!',
          duration: const Duration(milliseconds: 2000));
    }
  }

  void _resetPassword(context) {
    if (_formKey.currentState?.validate() ?? false) {
      UICommon.customScaffoldMessager(
          context: context,
          message: 'Password set successfully.',
          duration: const Duration(milliseconds: 2000));
      _tabController.animateTo(3);
    }
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    final imageTemporary = File(image.path);
    setState(() => _avatarImage = imageTemporary);
  }

  Future<void> _saveAccount(context) async {
    if (_nameController.text.isNotEmpty) {
      // Here we would save the user data to SQLite
      // Convert the image to data for storage
      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String fileName = basename(_avatarImage!.path);
      // String savedPath = '${appDocDir.path}/$fileName';

      // await _avatarImage!.copy(savedPath);

      Future<int?> id = _userDB.create(
          user: User(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text.trim(),
              image: null,
              isUsing: false));
      if (id != null && id != 0) {
        UICommon.customScaffoldMessager(
            context: context,
            message: 'Account created successfully.',
            duration: const Duration(milliseconds: 2000));
      } else {
        UICommon.customScaffoldMessager(
            context: context,
            message: 'Something went wrong! Software is updating...',
            duration: const Duration(milliseconds: 2000));
      }

      // Clear fields or navigate to another screen as needed
    } else {
      UICommon.customScaffoldMessager(
          context: context,
          message: 'Please provide all details and avatar image!',
          duration: const Duration(milliseconds: 2000));
    }
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
                      'Sign your new account',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Welcome to master video call',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildPhoneNumberTab(),
                        _buildVerificationCodeTab(),
                        _buildPasswordTab(),
                        _buildAccountDetailsTab(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    '${_tabController.index + 1} / 4', // Display the current tab number
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            )),
            Container(
              width: 1000,
              height: 250,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_tabController.index == 0) {
                        _validatePhoneNumber(context);
                      } else if (_tabController.index == 1) {
                        _verifyCode(context);
                      } else if (_tabController.index == 2) {
                        _resetPassword(context);
                      } else if (_tabController.index == 3) {
                        _saveAccount(context);
                      }
                    },
                    style: UICommon.customButtonStyle(),
                    child: Text(_tabController.index != 3 ? "Next" : "Finish"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: UICommon.customDecoration(
              labelText: "Your phone number", prefixIcon: Icons.phone),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number!';
            } else if (value.length != 10) {
              return 'Phone number must be 10 digits!';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildVerificationCodeTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: UICommon.customDecoration(
                  labelText: "Verification Code",
                  prefixIcon: Icons.verified_user),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the verification code';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: _isHidePassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
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
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetailsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Name',
                prefixIcon: Icon(Icons.person),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            // const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   onPressed: _pickImage,
            //   icon: const Icon(Icons.image),
            //   label: const Text('Choose Avatar Image'),
            //   style: ElevatedButton.styleFrom(),
            // ),
            // const SizedBox(height: 20),
            // _avatarImage == null
            //     ? const Text('No image selected.')
            //     : Image.file(
            //         _avatarImage!,
            //         width: 100,
            //         height: 100,
            //         fit: BoxFit.cover,
            //       ),
          ],
        ),
      ),
    );
  }
}
