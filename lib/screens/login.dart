import 'package:chatresume/main.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String accessCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 34, 42, 1),
      body: Container(
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          InkWell(
            onTap: () {
              MyFluroRouter.router.navigateTo(context, "/");

              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Chat()),
              //   (route) => false,
              // );
            },
            child: const Image(
              height: 128,
              width: 128,
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Welcome",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          const SizedBox(
            height: 12,
          ),

          //카카오 계정

          //구글 계정
          SizedBox(
            height: 48,
            width: MediaQuery.of(context).size.width > 1000
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width > 700
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Uri uri = Uri.parse(
                  "https://chat-profile.audrey.kr/api/user/google/login/",
                );

                launchUrl(uri,
                    mode: LaunchMode.inAppWebView,
                    webViewConfiguration: const WebViewConfiguration(),
                    webOnlyWindowName: "_self");
              },
              icon: const Row(
                children: [
                  Image(
                    image: AssetImage("assets/images/google.png"),
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8),
                ],
              ),
              label: const Text('구글 계정으로 시작하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: Colors.black54)),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
