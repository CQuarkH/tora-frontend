import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  PersistentTabController? _controller;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.selectedIndex);
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller?.index = widget.selectedIndex;
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        navBarHeight: 75,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
       
       
        navBarStyle: NavBarStyle.style19, // Estilo con diseño personalizado
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(25.0),
          colorBehindNavBar: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 8),
              blurRadius: 20,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        onItemSelected: (index) {
          setState(() {
            _controller?.index = index;
            selectedIndex = index;
          });
          
          // Integración con go_router
          _navigateToRoute(context, index);
          
          // Callback opcional
          widget.onItemTapped?.call(index);
        },
      ),
    );
  }

  void _navigateToRoute(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/child/calendar');
        break;
      case 1:
        context.go('/child/recommendations');
        break;
      case 2:
        context.go('/child/alerts');
        break;
      case 3:
        context.go('/child/pet');
        break;
      case 4:
        context.go('/child/communication');
        break;
    }
  }

  List<Widget> _buildScreens() {
    return [
      _buildScreenWithAppBar("Calendario", ChildCalendarScreen()),
      _buildScreenWithAppBar("Recomendaciones", const _PlaceholderScreen(title: "Recomendaciones")),
      _buildScreenWithAppBar("Alertas", const _PlaceholderScreen(title: "Alertas")),
      _buildScreenWithAppBar("Mascota", const _PlaceholderScreen(title: "Mascota")),
      _buildScreenWithAppBar("Comunicación", const _PlaceholderScreen(title: "Comunicación")),
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
      // Calendar
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Image.asset(
                'assets/images/icons/calendar.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/calendar.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: 'Calendario',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 10),
      ),
      // Topics
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Image.asset(
                'assets/images/icons/topic.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/topic.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: 'Temas',
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 10),
      ),
      // Central Button - Alertas
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/icons/aaa.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/images/icons/aaa.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: 'Alertas',
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 10),
      ),
      // Pet
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Image.asset(
                'assets/images/icons/paw.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/paw.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: 'Mascota',
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 10),
      ),
      // Communication
      PersistentBottomNavBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Image.asset(
                'assets/images/icons/speaker.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/images/icons/speaker.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: 'Audio',
        activeColorPrimary: Colors.cyan,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 10),
      ),
    ];
  }
}

// Widget auxiliar para pantallas placeholder
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'En desarrollo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}