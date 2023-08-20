import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:my_book_store/page/freezed/home_page.dart';
import 'package:my_book_store/page/onboard_page.dart';
import 'package:my_book_store/page/splash_page.dart';

import 'config/theme.dart';

void main() {
  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Book Store',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light(),
      darkTheme: MyTheme.dark(),
      themeMode: _themeMode,
      home: const Splash(),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage(),),
        /*GetPage(name: '/home', page: () {
            return ChangeNotifierProvider(
              create: (context) => BookProvider(BookApi()),
              builder: (context, child) {
                return const HomePage();
              },
            );
          }
        ),*/
        GetPage(
          name: '/onboard',
          page: () => const OnBoard(),
        ),
      ],
    );
  }
}
