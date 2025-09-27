import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/widgets/user_type_card.dart';

class ForkUsersScreen extends HookWidget {
  const ForkUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUserType = useState<String?>(null);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
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
                      const SizedBox(height: 40),

                      /// Header
                      Text(
                        '¡Bienvenido a Tora!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Selecciona tu tipo de usuario para comenzar',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
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
                                      description:
                                          'Accede a tu calendario, mascota virtual y actividades',
                                      icon: Icons.child_care,
                                      iconColor: Colors.blue[700]!,
                                      bgColor: Colors.blue[100]!,
                                      isSelected: selectedUserType.value == 'child',
                                      onTap: () => selectedUserType.value = 'child',
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Padre/Madre',
                                      description:
                                          'Gestiona y supervisa las actividades de tu hijo/a',
                                      icon: Icons.family_restroom,
                                      iconColor: Colors.green[700]!,
                                      bgColor: Colors.green[100]!,
                                      isSelected: selectedUserType.value == 'parent',
                                      onTap: () => selectedUserType.value = 'parent',
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Niño/a',
                                      description:
                                          'Accede a tu calendario, mascota virtual y actividades',
                                      icon: Icons.child_care,
                                      iconColor: Colors.blue[700]!,
                                      bgColor: Colors.blue[100]!,
                                      isSelected: selectedUserType.value == 'child',
                                      onTap: () => selectedUserType.value = 'child',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: UserTypeCard(
                                      title: 'Padre/Madre',
                                      description:
                                          'Gestiona y supervisa las actividades de tu hijo/a',
                                      icon: Icons.family_restroom,
                                      iconColor: Colors.green[700]!,
                                      bgColor: Colors.green[100]!,
                                      isSelected: selectedUserType.value == 'parent',
                                      onTap: () => selectedUserType.value = 'parent',
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 30),

                      /// Continue button
                      ElevatedButton(
                        onPressed: selectedUserType.value != null
                            ? () => _navigateToUserScreen(context, selectedUserType.value!)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Continuar',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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
    );
  }

  void _navigateToUserScreen(BuildContext context, String userType) {
    switch (userType) {
      case 'child':
        context.go('/child-main');
        break;
      case 'parent':
        context.go('/login');
        break;
    }
  }
}

