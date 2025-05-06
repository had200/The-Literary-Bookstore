import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';

void main() {
  runApp(const BookstoreApp());
}

class BookstoreApp extends StatefulWidget {
  const BookstoreApp({super.key});

  @override
  State<BookstoreApp> createState() => _BookstoreAppState();
}

class _BookstoreAppState extends State<BookstoreApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "The Literary Bookstore",
      themeMode: _themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: HomeScreen(changeTheme: _changeTheme),
    );
  }

  ThemeData _buildLightTheme() {
    final baseTextTheme = GoogleFonts.merriweatherTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Colors.brown,
        secondary: Colors.brown[800]!,
        surface: const Color(0xFFF5F0E1),
        background: const Color(0xFFF5F0E1),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F0E1),
      cardTheme: CardTheme(
        color: const Color(0xFFF8E1C4),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.brown,
        titleTextStyle: GoogleFonts.merriweather(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: Colors.brown[800],
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: Colors.black87,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final baseTextTheme = GoogleFonts.merriweatherTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Colors.brown[300]!,
        secondary: Colors.brown[200]!,
        surface: const Color(0xFF1E1B18),
        background: const Color(0xFF121212),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2C),
        elevation: 6,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.brown[800],
        titleTextStyle: GoogleFonts.merriweather(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: Colors.brown[200],
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: const Color(0xFFD4C2A8),
        ),
      ),
    );
  }
}