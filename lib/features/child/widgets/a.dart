
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PersistentTabController? _controller;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        stateManagement: true,
        backgroundColor: Colors.white,
        navBarStyle: NavBarStyle.style15,
        navBarHeight: 75,
        // PROPIEDADES PARA EFECTO FLOTANTE
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(25.0),
          colorBehindNavBar: Colors.transparent,
         
          border: Border.all(
            
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        onItemSelected: (final index) {
          setState(() {
            _controller?.index = index; 

            if (index == 1) {}
          });
        },
      ),
    );
  }

  


  List<Widget> _buildScreens() {
    return [
      const ChildCalendarScreen(),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              child: Image.asset( 
                'assets/images/icons/calendar.png',
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/calendar.png',
                ),
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              child: Image.asset(
                'assets/images/icons/paw.png',
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/paw.png',
                ),
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(

        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/icons/alert.png',
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child:  Image.asset(
                'assets/images/icons/alert.png',
              ),
            ),
          ],
        ),

        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent
  
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              child: Image.asset(
                'assets/images/icons/speaker.png',
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/speaker.png',
                ),
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.cyan,
        inactiveColorPrimary: Colors.grey,
      ),
      // Agregar quinto elemento para topic
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              child: Image.asset(
                'assets/images/icons/topic.png',
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/topic.png',
                ),
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}