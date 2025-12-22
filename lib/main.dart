
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const RecipeListApp());
}

class RecipeListApp extends StatefulWidget {
  const RecipeListApp({super.key});

  @override
  State<RecipeListApp> createState() => _RecipeListAppState();


  static _RecipeListAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_RecipeListAppState>()!;
}

class _RecipeListAppState extends State<RecipeListApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode? mode) {
    if (mode == null) {
      setState(() {
        if (_themeMode == ThemeMode.light) {
          _themeMode = ThemeMode.dark;
        } else if (_themeMode == ThemeMode.dark) {
          _themeMode = ThemeMode.light;
        } else {
          _themeMode = ThemeMode.light;
        }
      });
    } else {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {

    const Color lightPrimary = Colors.teal;
    const Color darkPrimary = Color(0xFF004D40);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Viewer',

      // Light Theme
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: lightPrimary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          color: lightPrimary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: lightPrimary,
          brightness: Brightness.dark,

          surface: Colors.grey.shade900,
          background: Colors.black,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          color: darkPrimary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: _themeMode,

      home: const RecipeListScreen(),
    );
  }
}