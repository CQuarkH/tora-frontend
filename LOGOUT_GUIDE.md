# Funcionalidad de Cerrar Sesión - Guía de Uso

## LogoutHelper

Este helper proporciona varias maneras de implementar la funcionalidad de cerrar sesión en tu aplicación Flutter.

### Formas de usar LogoutHelper:

#### 1. **Botón en AppBar** (Actualmente implementado)
```dart
// En el AppBar
actions: [
  LogoutHelper.logoutAppBarAction(
    context, 
    customMessage: '¿Estás seguro de que quieres salir de tu aventura?'
  ),
],
```

#### 2. **Botón directo**
```dart
// Como botón independiente
LogoutHelper.logoutButton(
  context,
  customMessage: '¿Quieres cerrar sesión?',
  buttonText: 'Salir'
),
```

#### 3. **En un Drawer/Menú lateral**
```dart
// En un Drawer
Drawer(
  child: ListView(
    children: [
      // otros elementos...
      LogoutHelper.logoutDrawerTile(
        context,
        customMessage: '¿Confirma que desea cerrar sesión?'
      ),
    ],
  ),
),
```

#### 4. **Llamar directamente al diálogo**
```dart
// Desde cualquier lugar
LogoutHelper.showLogoutDialog(
  context,
  customMessage: 'Mensaje personalizado aquí'
);
```

## Funcionalidades implementadas:

### ✅ Para Niños:
- Botón de logout en el AppBar de `ChildMainScreen`
- Mensaje personalizado: "¿Estás seguro de que quieres salir de tu aventura?"

### ✅ Para Padres:
- Botón de logout en el AppBar de `ParentMainScreen`
- Mensaje personalizado: "¿Está seguro de que desea cerrar sesión?"

### ✅ Comportamiento:
1. **Confirmación**: Muestra un diálogo de confirmación antes de cerrar sesión
2. **Limpieza**: Llama a `UserSession.logout()` para limpiar el estado
3. **Navegación**: Regresa automáticamente a la pantalla de selección de usuario (`/`)
4. **Feedback**: Muestra un SnackBar confirmando el cierre de sesión

## Personalización:

Puedes personalizar los mensajes de confirmación para cada contexto:
- **Niños**: Lenguaje más amigable y lúdico
- **Padres**: Lenguaje más formal y directo