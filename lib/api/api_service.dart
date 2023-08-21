import 'dart:async';
import 'dart:convert';
import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart' as http;
import 'package:web_browser_detect/web_browser_detect.dart';

class ApiService {
  static const String Url = "https://wine-api.audrey.kr";

  static Stream<String> sendData(String userChat, int chatId) async* {
    Uri apiUrl;
    if (chatId == -1) {
      apiUrl = Uri.parse(Url);
    } else {
      apiUrl = Uri.parse("$Url/$chatId");
    }

    var data = {"text": userChat};
    var body = json.encode(data);
    final browser = Browser().browser;
    final isUnusualBrower =
        !browser.contains("Safari") && !browser.contains("Chrome");

    final request = http.Request("POST", apiUrl)
      ..headers["Content-Type"] = "application/json"
      ..body = body;
    final client =
        isUnusualBrower ? http.Client() : FetchClient(mode: RequestMode.cors);

    try {
      final response = await client.send(request);
      final stream = response.stream.transform(utf8.decoder);

      await for (final message in stream) {
        yield message;
      }
    } catch (error) {
      yield "Error on OpenAI";
    }
  }

  static Future<List<String>> getExamples(int id) async {
    final apiUrl = Uri.parse("$Url/example/$id");
    try {
      final response = await http.get(apiUrl);
      List<String> examples = response.body.split("|");
      return examples;
    } catch (error) {
      return [];
    }
  }
}
