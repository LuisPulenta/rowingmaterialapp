import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/models/user.dart';
import 'package:rowingmaterialapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

//--------------------------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//--------------------------------------------------------------------------
class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getHome();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Rowing App',
      theme: ThemeData(
        //useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF781f1e),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF242424), foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
      ),
      home: _isLoading
          ? const WaitScreen()
          : _showLoginPage
              ? const LoginScreen()
              : HomeScreen(
                  user: _user,
                  imei: "",
                ),
    );
  }

//--------------------------------------------------------------------------
  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRemembered = prefs.getBool('isRemembered') ?? false;

    if (isRemembered) {
      String? userBody = prefs.getString('userBody');
      String date = prefs.getString('date').toString();
      String dateAlmacenada = date.substring(0, 10);
      String dateActual = DateTime.now().toString().substring(0, 10);
      if (userBody != null) {
        var decodedJson = jsonDecode(userBody);
        _user = User.fromJson(decodedJson);
        if (dateAlmacenada != dateActual) {
          _showLoginPage = true;
        } else {
          _showLoginPage = false;
        }
      }
    }

    _isLoading = false;
    setState(() {});
  }
}
