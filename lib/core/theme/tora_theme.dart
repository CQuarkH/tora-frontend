import 'package:flutter/material.dart';

class ToraTheme {
  // Colores primarios pasteles
  static const Color warmYellow = Color(0xFFFAB424); // FAB424 - Amarillo cálido
  static const Color softBlue = Color(0xFFA7C7E7); // A7C7E7 - Azul suave
  static const Color mintGreen = Color(0xFFA8D5BA); // A8D5BA - Verde menta
  static const Color lightGray = Color(0xFFE6E6E6); // E6E6E6 - Gris claro
  static const Color pureWhite = Color(0xFFFFFFFF); // FFFFFF - Blanco puro

  // Colores adicionales para mejor contraste y accesibilidad
  static const Color darkText = Color(0xFF2D3748);
  static const Color mediumText = Color(0xFF4A5568);
  static const Color lightText = Color(0xFF718096);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFDD6B20);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: warmYellow,
        brightness: Brightness.light,
        primary: warmYellow,
        primaryContainer: softBlue,
        secondary: mintGreen,
        secondaryContainer: lightGray,
        surface: pureWhite,
        background: pureWhite,
        error: errorColor,
        onPrimary: darkText,
        onSecondary: darkText,
        onSurface: darkText,
        onBackground: darkText,
        outline: lightGray,
      ),

      // AppBar Theme - Diseño limpio y suave
      appBarTheme: const AppBarTheme(
        backgroundColor: pureWhite,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: darkText, size: 24),
      ),

      // Card Theme - Bordes redondeados y sombra suave
      cardTheme: CardThemeData(
        color: pureWhite,
        elevation: 2,
        shadowColor: lightGray.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button - Botón principal con colores calmantes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmYellow,
          foregroundColor: darkText,
          elevation: 2,
          shadowColor: warmYellow.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Outlined Button - Botón secundario
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkText,
          side: const BorderSide(color: softBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Text Button - Botón de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mediumText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // FloatingActionButton - FAB con color calmante
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mintGreen,
        foregroundColor: darkText,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Input Decoration - Campos de texto amigables
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: softBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(
          color: mediumText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: lightText, fontSize: 16),
      ),

      // Bottom Navigation Bar - Navegación suave
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: pureWhite,
        selectedItemColor: warmYellow,
        unselectedItemColor: lightText,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Chip Theme - Para etiquetas y categorías
      chipTheme: ChipThemeData(
        backgroundColor: lightGray.withOpacity(0.5),
        selectedColor: softBlue.withOpacity(0.7),
        labelStyle: const TextStyle(
          color: darkText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        pressElevation: 2,
      ),

      // Divider Theme - Separadores sutiles
      dividerTheme: DividerThemeData(
        color: lightGray.withOpacity(0.6),
        thickness: 1,
        space: 16,
      ),

      // Switch Theme - Interruptores amigables
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return warmYellow;
          }
          return lightGray;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return warmYellow.withOpacity(0.3);
          }
          return lightGray.withOpacity(0.3);
        }),
      ),

      // Typography - Tipografía clara y legible
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: darkText,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: darkText,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkText,
          letterSpacing: 0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkText,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkText,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkText,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkText,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: mediumText,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkText,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkText,
          letterSpacing: 0.25,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mediumText,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkText,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: mediumText,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: mediumText,
          letterSpacing: 0.5,
        ),
      ),

      // Configuraciones adicionales para accesibilidad
      visualDensity: VisualDensity.comfortable,
      splashColor: warmYellow.withOpacity(0.1),
      highlightColor: softBlue.withOpacity(0.1),
    );
  }

  // Método para obtener gradientes suaves
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [warmYellow, Color(0xFFFDC74C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get secondaryGradient => const LinearGradient(
    colors: [softBlue, Color(0xFFB8D4F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [mintGreen, Color(0xFFB8E0C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras suaves para elementos flotantes
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: lightGray.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: lightGray.withOpacity(0.1),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}

// Extensión para fácil acceso a los colores del tema
extension NeuroFriendlyColors on BuildContext {
  Color get warmYellow => ToraTheme.warmYellow;
  Color get softBlue => ToraTheme.softBlue;
  Color get mintGreen => ToraTheme.mintGreen;
  Color get lightGray => ToraTheme.lightGray;
  Color get pureWhite => ToraTheme.pureWhite;
  Color get darkText => ToraTheme.darkText;
  Color get mediumText => ToraTheme.mediumText;
  Color get lightText => ToraTheme.lightText;
}
