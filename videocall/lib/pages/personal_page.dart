import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'dart:io';

import 'package:videocall/helpers/common.dart';
import 'package:videocall/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonalPage(),
    );
  }
}

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _selectedImage;
  MemoryImage? _currentUserImage;
  bool _isLoading = false;
  late User? _currentUser;
  final UserDB _userDB = UserDB();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeUserInfo();
  }

  Future<void> _initializeUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = await SharedPreferencesHelper.getInt('userId');
      if (userId != null) {
        final userInfor = await _userDB.fetchById(userId);
        setState(() {
          _currentUser = userInfor;
          _nameController.text = userInfor.name;
          _phoneController.text = userInfor.phone;
          if (userInfor.image != null) {
            Common.blobToImageWidget(userInfor.image!).then((value) {
              setState(() {
                _currentUserImage = value;
              });
            });
          }
        });
      }
    } catch (e) {
      print('Error initializing user information: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveInformation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentUser != null) {
        User updatedUser = _currentUser!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        if (_selectedImage != null) {
          // If a new image is selected, convert it to BLOB and update
          final compressImageFIle = await Common.compressImage(_selectedImage!);
          final blobImage = await Common.imageFileToBlob(compressImageFIle);
          updatedUser = updatedUser.copyWith(image: blobImage);
        } else if (_currentUserImage == null) {
          // If no new image is selected and there is no current image, clear the image field
          updatedUser = updatedUser.copyWith(image: null);
        }

        // Update the user in the database
        final result = await _userDB.update(user: updatedUser);
        if (result != null) {
          Common.customScaffoldMessager(
              // ignore: use_build_context_synchronously
              context: context,
              message: "Account was updated!");
        }
      }
    } catch (e) {
      print('Error saving information: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
      ),
      backgroundColor: Colors.blue[700],
      title: const Text('Change Personal Information'),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

  Widget _body2() {
    return _buildPhoneNumberTab2();
  }

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
                    // const Text(
                    //   "Change personal information",
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w300,
                    //       letterSpacing: 0.0000001),
                    // ),
                    // SizedBox.fromSize(size: const Size(0, 15)),
                    Center(
                      child: CircleAvatar(
                        radius: 120,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) // Show picked image
                            : (_currentUserImage ??
                                    const AssetImage(
                                        'assets/images/default_avatar.jpg'))
                                as ImageProvider, // Show default image if none selected
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            style: Common.customButtonStyle(
                                fontSize: 15,
                                backgroundColorHover:
                                    const Color.fromARGB(255, 91, 198, 251),
                                textColorHover:
                                    const Color.fromARGB(255, 6, 45, 102),
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                circular: 4,
                                size: const Size(200, 40),
                                boderSideColor:
                                    const Color.fromARGB(255, 91, 198, 251)),
                            child: const Text(
                              'Choose from Gallery',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            style: Common.customButtonStyle(
                                fontSize: 15,
                                backgroundColorHover:
                                    const Color.fromARGB(255, 91, 198, 251),
                                textColorHover:
                                    const Color.fromARGB(255, 6, 45, 102),
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                circular: 4,
                                size: const Size(200, 40),
                                boderSideColor:
                                    const Color.fromARGB(255, 91, 198, 251)),
                            child: const Text(
                              'Take a Picture',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox.fromSize(size: const Size(0, 15)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        enabled: false,
                        cursorColor: Colors.blue.shade400,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
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
                    SizedBox.fromSize(size: const Size(0, 15)),
                    Material(
                      shadowColor: Colors.blue.shade500.withOpacity(0.3),
                      elevation: 2.8,
                      child: TextFormField(
                        cursorColor: Colors.blue.shade400,
                        textAlignVertical: const TextAlignVertical(y: 1),
                        controller: _nameController,
                        style: const TextStyle(
                            fontSize: 16, height: 0.8, letterSpacing: 0.0001),
                        decoration:
                            Common.customDecoration2(labelText: 'Account Name'),
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
                    onPressed: _saveInformation,
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
                      'Save',
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: _appBar(),
          body: _body2(),
        ),
        if (_isLoading) Common.circularProgress()
      ],
    );
  }
}
