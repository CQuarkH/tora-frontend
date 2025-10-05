import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';
import 'package:dotted_border/dotted_border.dart';

class ChildMainScreen extends StatefulWidget {
  const ChildMainScreen({super.key});

  @override
  State<ChildMainScreen> createState() => _ChildMainScreenState();
}

class _ChildMainScreenState extends State<ChildMainScreen> {
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
          });
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildScreenWithAppBar("Calendario", const ChildCalendarScreen()),
      _buildScreenWithAppBar("Recomendaciones", const Placeholder()),
      _buildScreenWithAppBar("Alertas", const Placeholder()),
      _buildScreenWithAppBar("Comunicación", const Placeholder()),
      _buildScreenWithAppBar("Temas", const Placeholder()),
    ];
  }

  Widget _buildScreenWithAppBar(String title, Widget body) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/icons/tora.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          LogoutHelper.logoutAppBarAction(
            context,
            customMessage: '¿Estás seguro de que quieres salir de tu aventura?',
          ),
        ],
      ),
      body: body,
    );
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
              child: Image.asset(
                'assets/images/icons/alert.png',
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent,
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
      
    ];
  }
}
