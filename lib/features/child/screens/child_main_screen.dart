import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';
import 'package:tora_frontend/features/child/screens/communication-non-verbale/child_communication_non_verbale_screen.dart';
import 'package:tora_frontend/features/child/screens/recommendation-child/recommendation_child_screen.dart';
import 'package:tora_frontend/features/child/services/self_regulation_service.dart';
import 'package:tora_frontend/features/tora-pet/screens/tora_screen.dart';
import 'package:tora_frontend/core/widgets/alert_win_coins_helper.dart';
import 'package:tora_frontend/features/tora-pet/widgets/coins_widget.dart';

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
          border: Border.all(color: Colors.grey.shade300, width: 1),
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
      _buildScreenWithAppBar(
        "Recomendaciones",
        const ChildRecommendationScreen(),
      ),
      _buildScreenWithAppBar("Alertas", const Placeholder()),
      _buildScreenWithAppBar("Tora", const ToraScreen()),
      _buildScreenWithAppBar(
        "Temas",
        const ChildCommunicationNonVerbaleScreen(),
      ),
    ];
  }

  Widget _buildScreenWithAppBar(String title, Widget body) {
    return Scaffold(
      extendBody: true, // 👈 permite que el fondo fluya bajo el navbar flotante
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
          CoinsWidget(),
          const SizedBox(width: 10),
          LogoutHelper.logoutAppBarAction(
            context,
            customMessage: '¿Estás seguro de que quieres salir de tu aventura?',
          ),
        ],
      ),

      // 👇 Esto evita que el contenido quede oculto tras el navbar flotante
      body: SafeArea(
        bottom: false, // el padding manual se encargará del espacio
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
          ), // altura aprox. del navbar + margen
          child: body,
        ),
      ),
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
              child: Image.asset('assets/images/icons/calendar.png'),
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
                child: Image.asset('assets/images/icons/calendar.png'),
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
              child: Image.asset('assets/images/icons/topic.png'),
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
                child: Image.asset('assets/images/icons/topic.png'),
              ),
            ),
          ],
        ),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        onPressed: (unnamed) =>
            SelfRegulationService.showRegulationFlow(context),
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Image.asset('assets/images/icons/alert.png'),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Image.asset('assets/images/icons/alert.png'),
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
              child: Image.asset('assets/images/icons/paw.png'),
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
                child: Image.asset('assets/images/icons/paw.png'),
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
              child: Image.asset('assets/images/icons/speaker.png'),
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
                child: Image.asset('assets/images/icons/speaker.png'),
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
