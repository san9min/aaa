// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class LoginAPI {
//   static const String Url = "https://chat-profile.audrey.kr/api/user/test";

//   static Future<bool> checkLogin() async {
//     try {
//       final response = await http.get(Uri.parse(Url));

//       if (jsonDecode(response.body)["status"] == "Fail") {
//         return false;
//       } else {
//         return true;
//       }
//     } catch (error) {
//       return false;
//     }
//   }
// }
