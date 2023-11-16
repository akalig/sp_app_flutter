import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screens/notifications.dart';
import 'home_screens/home.dart';
import 'home_screens/news.dart';
import 'home_screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List screens = [
    const Home(),
    const News(),
    const Notifications(),
    const Profile(),
  ];

  int currentIndex = 0;
  PageController controller = PageController();

  void nextPage(index) {
    setState(() {
      currentIndex = index;
      controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(Icons.assignment_ind_outlined, color: Colors.black54, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        nextPage(0);
                      },
                      icon: Icon(Icons.home, color: currentIndex==0?Colors.green:Colors.grey),
                    ),
                    Text('Home', style: TextStyle(fontSize: 12, color: currentIndex==0?Colors.green:Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets. only(right: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          nextPage(1);
                        },
                        icon: Icon(Icons.article_rounded, color: currentIndex==1?Colors.green:Colors.grey),
                      ),
                      Text('News', style: TextStyle(fontSize: 12, color: currentIndex==1?Colors.green:Colors.grey)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          nextPage(2);
                        },
                        icon: Icon(Icons.notifications, color: currentIndex==2?Colors.green:Colors.grey),
                      ),
                      Text('Notifications', style: TextStyle(fontSize: 12, color: currentIndex==2?Colors.green:Colors.grey)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        nextPage(3);
                      },
                      icon: Icon(Icons.dashboard, color: currentIndex==3?Colors.green:Colors.grey),
                    ),
                     Text('Profile', style: TextStyle(fontSize: 12, color: currentIndex==3?Colors.green:Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: PageView.builder(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          itemCount: screens.length,
          itemBuilder: (context, index) {

        return screens[index];
      }),
    );
  }
}