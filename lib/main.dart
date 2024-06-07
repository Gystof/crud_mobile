import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'package:projectapps/providers/auth_provider.dart';
import 'package:projectapps/providers/theme_provider.dart';

import 'package:projectapps/screens/auth_screen.dart';
import 'package:projectapps/screens/splash_screen.dart';
import 'package:projectapps/screens/home_screen.dart';
import 'package:projectapps/screens/profile_screen.dart';
import 'package:projectapps/screens/request_detail_screen.dart';
import 'package:projectapps/screens/user_detail_screen.dart';

import 'package:projectapps/models/request.dart';
import 'package:projectapps/models/user.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Обеспечивает инициализацию виджетов
  await Firebase.initializeApp(); // Инициализация Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'Project Apps',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
            ),
            themeMode: themeProvider.themeMode,
            home: SplashScreen(),
            routes: {
              '/auth': (context) => AuthScreen(),
              '/home': (context) => HomeScreen(),
              '/profile': (context) => ProfileScreen(),
              '/request_detail': (context) => RequestDetailScreen(
                  request:
                      ModalRoute.of(context)!.settings.arguments as Request),
              '/user_detail': (context) => UserDetailScreen(
                  user: ModalRoute.of(context)!.settings.arguments as User),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
