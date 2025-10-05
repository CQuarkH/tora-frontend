import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/widgets/user_type_card.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class ForkUsersScreen extends HookWidget {
  const ForkUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUserType = useState<String?>(null);
    final tapCount = useState<Map<String, int>>({'child': 0, 'parent': 0});

    void handleUserTap(String userType) {
      // Incrementar el contador de toques para este tipo de usuario
      tapCount.value = {
        ...tapCount.value,
        userType: (tapCount.value[userType] ?? 0) + 1,
      };

      // Actualizar la selección visual
      selectedUserType.value = userType;

      // Si es el segundo toque, navegar directamente
      if (tapCount.value[userType] == 2) {
        _navigateToUserScreen(context, userType);
      }

      // Resetear el contador del otro tipo de usuario
      final otherType = userType == 'child' ? 'parent' : 'child';
      tapCount.value = {
        ...tapCount.value,
        otherType: 0,
      };
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.pureWhite,
              context.lightGray.withOpacity(0.3),
              context.softBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            return SingleChildScrollView(
              
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),

                      /// 
                      Text(
                        '¡Bienvenido a Tora!',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900
                          ,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Selecciona tu tipo de usuario para comenzar',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      /// User cards (responsive: column en móviles, row en tablets/escritorio)
                      Expanded(
                        child: isWide
                            ? Row(
                                children: [
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Niño/a',
                                      description: 'Accede a tu calendario, mascota virtual y actividades para una experiencia divertida',
                                      icon: Icons.child_care,
                                      iconColor: context.darkText,
                                      bgColor: context.softBlue.withOpacity(0.3),
                                      isSelected: selectedUserType.value == 'child',
                                      onTap: () => handleUserTap('child'),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Padre/Madre',
                                      description: 'Gestiona y supervisa las actividades de tu hijo/a de manera fácil y efectiva',
                                      icon: Icons.family_restroom,
                                      iconColor: context.darkText,
                                      bgColor: context.mintGreen.withOpacity(0.3),
                                      isSelected: selectedUserType.value == 'parent',
                                      onTap: () => handleUserTap('parent'),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Niño/a',
                                      description: 'Accede a tu calendario, mascota virtual y actividades para una experiencia divertida',
                                      icon: Icons.child_care,
                                      iconColor: context.darkText,
                                      bgColor: context.softBlue.withOpacity(0.3),
                                      isSelected: selectedUserType.value == 'child',
                                      onTap: () => handleUserTap('child'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Padre/Madre',
                                      description: 'Gestiona y supervisa las actividades de tu hijo/a de manera fácil y efectiva',
                                      icon: Icons.family_restroom,
                                      iconColor: context.darkText,
                                      bgColor: context.mintGreen.withOpacity(0.3),
                                      isSelected: selectedUserType.value == 'parent',
                                      onTap: () => handleUserTap('parent'),
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        ),
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context, String userType) {
    switch (userType) {
      case 'child':
        context.go('/child-login');
        break;
      case 'parent':
        context.go('/parent-login');
        break;
    }
  }
}

