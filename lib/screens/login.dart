import 'package:chatresume/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              onPressed: () async {
                Uri uri = Uri.parse(
                    "https://chat-profile.audrey.kr/api/user/google/login/");

                try {
                  final response = await http.post(uri);
                  print(response);
                  if (response.statusCode == 302) {
                    // 302 응답의 경우 새로운 위치로 리디렉션
                    String newLocation = response.headers["location"]!;
                    if (newLocation != null) {
                      Uri newUri = Uri.parse(newLocation);
                      final newResponse =
                          await http.get(newUri); // 또는 POST 요청 등을 사용
                      print(newResponse);
                      // 새로운 응답에 대한 처리
                    } else {
                      print(
                          "No 'Location' header in the redirection response.");
                    }
                  } else {
                    // 302 이외의 응답에 대한 처리
                    print(response);
                  }
                } catch (e) {
                  print(e);
                  print("Error: $e");
                }
                // launchUrl(
                //   uri,
                // ); // URL을 기본 브라우저로 열기
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
