import 'package:flutter/material.dart';
import 'home_page.dart';
import 'trade_page.dart';
import 'news_page.dart';
import 'profile_page.dart';
import 'package:barter_it/models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String mainTitles = 'BarterIt';
  int pageCount = 0;
  late List<Widget> pages;

  @override
  initState() {
    super.initState();
    pages = [
      HomePage(user: widget.user),
      TradePage(user: widget.user),
      NewsPage(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageCount == 0
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.teal,
                      Colors.cyan.shade300,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        mainTitles,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: pages[pageCount],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        selectedFontSize: 16,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.balance),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: pageCount,
        onTap: (int index) {
          setState(() {
            pageCount = index;
            if (index == 0) {
              mainTitles = "Home Page";
            } else if (index == 1) {
              mainTitles = "Trade Page";
            } else if (index == 2) {
              mainTitles = "News Page";
            } else if (index == 3) {
              mainTitles = "Profile";
            }
          });
          debugPrint("$pageCount");
        },
      ),
    );
  }
}
