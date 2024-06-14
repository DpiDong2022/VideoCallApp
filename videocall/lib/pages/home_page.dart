import 'package:flutter/material.dart';
import 'package:videocall/database/auth.dart';
import 'package:videocall/database/friend_ship_db.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'package:videocall/models/user.dart';
import 'package:videocall/pages/first_page.dart';
import 'package:videocall/pages/personal_page.dart';
import 'package:videocall/pages/security.dart';
import 'package:videocall/pages/user_card.dart';

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
  final FocusNode _searchFocusNode = FocusNode();
  final AuthDB _authDB = AuthDB();
  final _userDB = UserDB();
  final _friendDB = FriendShipDB();
  User? _currentUser;
  MemoryImage? _currentUserImage;
  List<User>? users = [];
  List<User>? allUsers = [];

  @override
  void initState() {
    super.initState();
    _searchInputController.addListener(_onSearchInputChanged);
    _pageController.addListener(_onInit);
    initInfor();
  }

  void _onSearchInputChanged() {
    if (_searchInputController.text.isEmpty) {
      // If the search input is empty, reset the users list or fetch default users
      setState(() {
        users = []; // or you can reset to a default set of users
      });
    } else {
      // If there's text in the search input, perform the search
      _search();
    }
  }

  void _onInit() async {
    setState(() async {
      allUsers = await _friendDB.fetchFriendsOfUser(
          await SharedPreferencesHelper.getInt('userId') ?? 0);
    });
  }

  void _search() {
    if (_searchInputController.text.trim() != null &&
        _searchInputController.text.trim().length > 0) {
      _userDB
          .fetchAll(phoneNumber: _searchInputController.text.trim())
          .then((value) {
        setState(() {
          users = value;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchInputController.removeListener(_onSearchInputChanged);
    _searchInputController.dispose();
    _pageController.dispose();
    _searchFocusNode.dispose();
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
                focusNode: _searchFocusNode,
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
                              _searchInputController.clear();
                              _search(); // Perform search after clearing to reset the list
                            },
                          )
                        : null),
                onChanged: (value) => {setState(() {})},
                onEditingComplete: () {
                  _search();
                },
                onFieldSubmitted: (value) => _searchFocusNode.unfocus(),
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
          case 'Personal Information':
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
          case 'Security':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SecurityPage()));
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'Personal Information',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Personal Information'),
            ],
          ),
        ),
        const PopupMenuDivider(
          height: 0,
        ),
        const PopupMenuItem(
          value: 'Security',
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Colors.blue),
              SizedBox(width: 8),
              Text('Security'),
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
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        // Content for the "Call" tab
        Center(
          child: allUsers!.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: allUsers!.length,
                  itemBuilder: (context, index) {
                    return UserCard(user: allUsers![index]);
                  },
                ),
        ),
        // Content for the "Add friend" tab
        Center(
          child: users!.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: users!.length,
                  itemBuilder: (context, index) {
                    return UserCard(user: users![index]);
                  },
                ),
        ),
      ],
    ));
  }

  Future<void> initInfor() async {
    setState(() {
      _isLoading = true;
    });

    allUsers = await _userDB.fetchAll();

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
