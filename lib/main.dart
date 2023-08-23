import 'package:chatresume/chat.dart';
import 'package:chatresume/screens/auth.dart';
import 'package:chatresume/screens/build.dart';
import 'package:chatresume/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluro/fluro.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  //setPathUrlStrategy(); // 해당 라인 추가.
  setUrlStrategy(PathUrlStrategy());
  MyFluroRouter.setupRouter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MyFluroRouter.router.generator,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 46, 50, 52),
        fontFamily: GoogleFonts.notoSans().fontFamily,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      //home: const Chat(),
      initialRoute: '/',
      // routes: {
      //   "/": (context) => const Chat(),
      //   "/login": (context) => const LoginScreen(),
      //   "/build": (context) => const BuildScreen()
      // },
    );
  }
}

class MyFluroRouter {
  static FluroRouter router = FluroRouter();

  static final Handler _HomePageHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const Chat());
  static final Handler _LoginPageHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const LoginScreen());

  static final Handler _BuildPageHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const BuildScreen());

  static final Handler _AuthHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const AuthScreen());

  static void setupRouter() {
    router.define("/",
        handler: _HomePageHandler, transitionType: TransitionType.fadeIn);
    router.define("/login",
        handler: _LoginPageHandler, transitionType: TransitionType.fadeIn);
    router.define("/build",
        handler: _BuildPageHandler, transitionType: TransitionType.fadeIn);
    router.define("/callback",
        handler: _AuthHandler, transitionType: TransitionType.fadeIn);
  }
}
