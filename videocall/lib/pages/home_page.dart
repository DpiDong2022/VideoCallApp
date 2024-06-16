import 'package:flutter/material.dart';
import 'package:videocall/database/auth.dart';
import 'package:videocall/database/friend_ship_db.dart';
import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/helpers/enum_helper.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'package:videocall/models/notification2.dart';
import 'package:videocall/models/user.dart';
import 'package:videocall/pages/first_page.dart';
import 'package:videocall/pages/notification_card.dart';
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
  List<Notification2> notifications = [
    Notification2(
        name: "Nguyen Viet Hai",
        at: "Just now",
        isFriendRequst: false,
        isAccepted: true,
        isSeen: false),
    Notification2(
        name: "Le Duy Dai",
        at: "One minute ago",
        isFriendRequst: true,
        isAccepted: true,
        isSeen: false),
    Notification2(
        name: "Thay giao Bach",
        at: "Three hours ago",
        isFriendRequst: true,
        isAccepted: false,
        isSeen: false),
    Notification2(
        name: "Thay Sinh",
        at: "One day ago",
        isFriendRequst: false,
        isAccepted: true,
        isSeen: false),
    Notification2(
        name: "Phung Dai Dong",
        at: "2024-06-11",
        isFriendRequst: true,
        isAccepted: false,
        isSeen: false),
    Notification2(
        name: "Dao Thi Bich Tram",
        at: "2024-06-15",
        isFriendRequst: true,
        isAccepted: false,
        isSeen: false),
    Notification2(
        name: "Nguyen Xuan Toan",
        at: "2024-011-14",
        isFriendRequst: true,
        isAccepted: false,
        isSeen: false),
  ];

  @override
  void initState() {
    super.initState();
    _searchInputController.addListener(_onSearchInputChanged);
    _pageController.addListener(_onInit);
    initInfor();
  }

  void _onSearchInputChanged() async {
    if (_searchInputController.text.isEmpty) {
      // If the search input is empty, reset the users list or fetch default users
      setState(() {
        users = []; // or you can reset to a default set of users
      });

      setState(() async {
        allUsers = await _friendDB.fetchFriendsOfUser(
            await SharedPreferencesHelper.getInt('userId') ?? 0, " ");
      });
    } else {
      // If there's text in the search input, perform the search
      _search();
      udpateFriends();
    }
  }

  void udpateFriends() async {
    setState(() async {
      allUsers = await _friendDB.fetchFriendsOfUser(
          await SharedPreferencesHelper.getInt('userId') ?? 0,
          _searchInputController.text.trim());
    });
  }

  void _onInit() async {
    setState(() async {
      allUsers = await _friendDB.fetchFriendsOfUser(
          await SharedPreferencesHelper.getInt('userId') ?? 0,
          _searchInputController.text.trim());
    });
  }

  Future<void> _search() async {
    if (_searchInputController.text.trim() != null &&
        _searchInputController.text.trim().length > 0) {
      _userDB
          .fetchAll(phoneNumber: _searchInputController.text.trim())
          .then((userss) async {
        if (userss.isNotEmpty) {
          if (userss[0].id == _currentUser!.id) {
            userss[0].userType = UserTypeEnum.ONESELF;
          } else if (await _friendDB.isFriend(
              _currentUser!.id!, userss[0].id!)) {
            userss[0].userType = UserTypeEnum.FRIEND;
          } else {
            userss[0].userType = UserTypeEnum.UNKNOWN;
          }

          setState(() {
            users = userss;
          });
        } else {
          setState(() {
            users = [];
          });
        }
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
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
                              setState(() async {
                                _search();
                                _onSearchInputChanged();
                              });
                            },
                          )
                        : null),
                onChanged: (value) => {
                  setState(() {
                    _onSearchInputChanged();
                  })
                },
                onEditingComplete: () {
                  _onSearchInputChanged();
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
      items: [
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts,
            ),
            label: "Contacts"),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.person_search),
              if (2 > 0)
                Positioned(
                  right: 0,
                  left: 15,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 15,
                    ),
                    child: const Center(
                      child: Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
            ],
          ),
          label: "Search friend",
        ),
      ],
    );
  }

  SafeArea _body() {
    return SafeArea(
        child: PageView(
      onPageChanged: (value) {
        _searchInputController.text = "";
        const AsyncSnapshot.waiting();
        udpateFriends();
      },
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        // Content for the "Call" tab
        Scrollbar(
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(20),
            child: allUsers!.isEmpty
                ? Container()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: allUsers!.length,
                    itemBuilder: (context, index) {
                      return UserCard(user: allUsers![index]);
                    },
                  )),
        // Content for the "Add friend" tab
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search result section
              Expanded(
                flex: 1,
                child: users!.isEmpty
                    ? const Center(child: Text('No users found'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: users!.length,
                        itemBuilder: (context, index) {
                          return UserCard(user: users![index]);
                        },
                      ),
              ),
              const PopupMenuDivider(
                height: 0,
              ),
              // Notifications heading
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 10, 20, 0),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 4,
                    radius: const Radius.circular(20),
                    child: notifications.isEmpty
                        ? const Center()
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              return NotificationCard(
                                  notification: notifications[index]);
                            },
                          ),
                  )),
            ],
          ),
        )
      ],
    ));
  }

  Future<void> initInfor() async {
    setState(() {
      _isLoading = true;
    });

    allUsers = await _friendDB.fetchFriendsOfUser(
        await SharedPreferencesHelper.getInt('userId') ?? 0,
        _searchInputController.text.trim());

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
