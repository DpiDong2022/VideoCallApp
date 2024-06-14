import 'package:flutter/material.dart';
import 'package:videocall/database/auth.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'package:videocall/models/user.dart';
import 'package:videocall/pages/first_page.dart';
import 'package:videocall/pages/personal_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomItemIndex = 0;
  bool _isLoading = false;
  final TextEditingController _searchInputController = TextEditingController();
  final PageController _pageController = PageController();
  final AuthDB _authDB = AuthDB();
  final _userDB = UserDB();
  User? _currentUser;
  MemoryImage? _currentUserImage; // Updated to nullable

  @override
  void initState() {
    super.initState();
    _searchInputController.addListener(() {
      setState(() {});
    });
    initInfor(); // Call the initialization function here
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: _appBar(),
            body: _body(),
            bottomNavigationBar: _bottomNavigation()),
        if (_isLoading) Common.circularProgress() // Loading indicator
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
        backgroundColor: Colors.blue[700],
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchInputController,
                cursorColor: const Color.fromARGB(255, 17, 172, 255),
                cursorHeight: 25,
                cursorRadius: const Radius.circular(50),
                mouseCursor: MouseCursor.defer,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    filled: true,
                    fillColor: Colors.white,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    hintText: "Search...",
                    hintStyle: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.normal),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    suffixIcon: _searchInputController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: Color.fromARGB(255, 0, 0, 0), size: 22),
                            onPressed: () {
                              _searchInputController
                                  .clear(); // Clear the text in the field
                              setState(() {});
                            },
                          )
                        : null),
                onChanged: (value) => {setState(() {})},
              ),
            ),
            const SizedBox(width: 17),
            _userAvatar()
          ],
        ));
  }

  Widget _userAvatar() {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      padding: const EdgeInsets.symmetric(),
      elevation: 15,
      offset: const Offset(0, 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      surfaceTintColor: Colors.white,
      onSelected: (value) {
        // Handle menu item selection
        switch (value) {
          case 'Edit Personal Information':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PersonalPage()));
            break;
          case 'Logout':
            setState(() {
              _isLoading = true;
              _authDB.logout(fakeDelayMiniSecond: 500).then((value) {
                _isLoading = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FirstPage()),
                    (route) => false);
              });
            });
            break;
          case 'Password':
            Common.customScaffoldMessager(
                message: 'Password', context: context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        // PopupMenuItem(
        //     child: IconButton(onPressed: () {}, icon: const Icon(Icons.close))),
        const PopupMenuItem(
          value: 'Edit Personal Information',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Edit Personal Information'),
            ],
          ),
        ),
        const PopupMenuDivider(
          height: 0,
        ),
        const PopupMenuItem(
          value: 'Password',
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.blue),
              SizedBox(width: 8),
              Text('Password'),
            ],
          ),
        ),
        const PopupMenuDivider(
          height: 0,
        ),
        const PopupMenuItem(
          value: 'Logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.blue),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20, // Adjust the size if necessary
        child: ClipOval(
          child: Image(
            image: _currentUserImage != null
                ? _currentUserImage!
                : const AssetImage('assets/images/default_avatar.jpg')
                    as ImageProvider,
            fit: BoxFit.cover,
            width: 100, // Adjust the size if necessary
            height: 100, // Adjust the size if necessary
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.blue[700],
      currentIndex: _bottomItemIndex,
      unselectedItemColor: Colors.white60,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      onTap: (index) {
        setState(() {
          _bottomItemIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.video_camera_front_outlined,
            ),
            label: "Call"),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group_add,
          ),
          label: "Add friend",
        )
      ],
    );
  }

  SafeArea _body() {
    return SafeArea(
        child: PageView(
      controller: _pageController,
      children: const [
        // Content for the "Call" tab
        Center(
          child: Text('Call Tab'),
        ),
        // Content for the "Add friend" tab
        Center(
          child: Text('Add Friend Tab'),
        ),
      ],
    ));
  }

  Future<void> initInfor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await SharedPreferencesHelper.getInt('userId');
      if (userId != null) {
        final userInfor = await _userDB.fetchById(userId);
        setState(() {
          _currentUser = userInfor;
        });

        if (userInfor.image != null && userInfor.image!.length > 0) {
          final userImage = await Common.blobToImageWidget(userInfor.image!);
          setState(() {
            _currentUserImage = userImage as MemoryImage?;
          });
        }
      }
    } catch (e) {
      // Handle any errors
      print('Error loading user information: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
