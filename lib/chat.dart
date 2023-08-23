import 'package:chatresume/api/api_service.dart';
import 'package:chatresume/api/login.dart';
import 'package:chatresume/model/user.dart';
import 'package:chatresume/model/user_candidates.dart';
import 'package:chatresume/product_card.dart';
import 'package:chatresume/screens/result.dart';
import 'package:chatresume/widget/conversation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cookie_wrapper/cookie.dart';
import 'package:chatresume/main.dart';

class Chat extends StatefulWidget {
  const Chat(
      {super.key,
      this.onlyChat = false,
      this.pickedFile,
      this.chatbot_name = ""});
  final bool onlyChat;
  final pickedFile;
  final String chatbot_name;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _loading = false;
  Timer? blinkingTimer;
  bool isExpansion = false;
  final textcontroller = TextEditingController();

  bool login = false;

  String? userName;
  String? userImg;

  List<ChatMessage> messages = [];
  List<Candidate> candidateList = [];

  int chatId = -1;

  bool isLoginButtonHovered = false;
  bool isSignUpButtonHovered = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
    candidateList = [
      Candidate(text: "사용 방법에 대해 알려주세요!"),
      Candidate(text: "audrey.AI는 무엇을 하나요?"),
      Candidate(text: "무엇을 물어볼 수 있나요?"),
    ];
  }

  void checkLogin() async {
    var cookie = Cookie.create();

    var accessToken = cookie.get('access_token');
    var refreshToken = cookie.get('refresh_token');

    if (accessToken != null && refreshToken != null) {
      final userNameImg = await UserInfo.getUserInfo(accessToken, refreshToken);
      if (userNameImg.isEmpty) {
        MyFluroRouter.router.navigateTo(context, "/login");
      }
      setState(() {
        userName = userNameImg['name'];
        userImg = userNameImg['user_image'];
        login = true;
      });
    } else {}
  }

  @override
  void dispose() {
    textcontroller.dispose();

    super.dispose();
  }

  void sendMessage(userInput) async {
    if (userInput.trim().isEmpty) {
      return;
    }
    setState(() {
      _loading = true;
      candidateList.clear();
      messages.add(ChatMessage(
        messageContent: userInput,
        messageType: "user",
        messageProduct: "",
      ));
      messages.add(ChatMessage(
        messageContent: "",
        messageType: "model",
        messageProduct: "",
      ));
    });

    final userChat = userInput.trim();

    textcontroller.clear();
    int id;
    List<String> exampleList = [];
    blinkingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (messages.last.messageContent.isEmpty) {
          messages.last.messageContent = "|";
        } else {
          messages.last.messageContent = "";
        }
      });
    });
    bool isFirstData = true;
    String cleanedResponse = "";
    await for (final message in ApiService.sendData(userChat, chatId)) {
      if (isFirstData) {
        blinkingTimer?.cancel();
        messages.last.messageContent = "";
        isFirstData = false;
      }

      if (message.contains("@@@")) {
        cleanedResponse = message.replaceAll("@@@", "");

        messages.add(ChatMessage(
          messageContent: "",
          messageType: "model",
          messageProduct: cleanedResponse,
        ));
        messages.add(ChatMessage(
          messageContent: "",
          messageType: "model",
          messageProduct: "",
        ));
        continue;
      }
      if (message.contains("#####chat_id:")) {
        setState(() {
          _loading = false;
        });
        id = int.parse(message.split("#####ex_id:")[1].trim());
        exampleList = await ApiService.getExamples(id);

        if (chatId == -1) {
          chatId = int.parse(
              message.split("#####chat_id:")[1].split("#####")[0].trim());
        }
        continue; // id 값이 할당되었으므로 루프를 빠져나옴
      }
      setState(() {
        messages.last.messageContent += message;
      });
    }

    setState(() {
      // if (cleanedResponse != "") {
      //   print("1 $cleanedResponse");
      //   print(cleanedResponse.runtimeType);

      // }
      for (final example in exampleList) {
        candidateList.add(Candidate(text: example));
      }
    });
  }

  void _handleNewChatPressed() {
    setState(() {
      _loading = false;
      messages.clear();
      chatId = -1;
      candidateList = [
        Candidate(text: "사용 방법에 대해 알려주세요!"),
        Candidate(text: "audrey.AI는 무엇을 하나요?"),
        Candidate(text: "무엇을 물어볼 수 있나요?"),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.onlyChat
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: widget.pickedFile == null
                          ? Image.asset('assets/images/logo.png',
                              width: 48, height: 48, fit: BoxFit.cover)
                          : Image.memory(widget.pickedFile!.bytes!,
                              width: 48, height: 48, fit: BoxFit.contain),
                    ),
                    Text(widget.chatbot_name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            fontSize: 18)),
                  ]),
              const Divider(color: Colors.grey, thickness: 1),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: content(messages, candidateList, true)),
              Column(
                children: [
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Center(
                    child: Container(
                      color: Colors.white,
                      child: const Text("Powered by @audrey.AI",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002855),
                              fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              )
            ],
          )
        : SafeArea(
            child: Scaffold(
                drawerEnableOpenDragGesture: false,
                appBar: (MediaQuery.of(context).size.width < 600)
                    ? AppBar(
                        title: const Image(
                          height: 36,
                          image: AssetImage('assets/images/weblogo.png'),
                          fit: BoxFit.contain,
                        ),
                        leading: Builder(
                          builder: (context) => // Ensure Scaffold is in context
                              IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer()),
                        ),
                        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                      )
                    : null,
                drawer: Drawer(
                  backgroundColor: const Color.fromARGB(255, 36, 36, 36),
                  child: BaseUI(context),
                ),
                body: Row(
                  children: [
                    MediaQuery.of(context).size.width > 600
                        ? Container(
                            width: 256,
                            color: const Color.fromARGB(255, 36, 36, 36),
                            child: BaseUI(context))
                        : Container(),
                    Expanded(
                        child:
                            content(messages, candidateList, widget.onlyChat)),
                  ],
                )));
  }

  Widget content(List<ChatMessage> message, candidateList, bool onlyChat) {
    return Stack(
      children: [
        //chat bubble view
        message.isEmpty && !onlyChat
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5 > 256
                          ? MediaQuery.of(context).size.width / 5
                          : 224,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 10,
                          left: MediaQuery.of(context).size.width / 32,
                          right: MediaQuery.of(context).size.width / 32),
                      child: const Image(
                        image: AssetImage('assets/images/audrey_logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 24),
                      child: Text(
                        "Demo for audrey.AI \n",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 156),
                child: ListView.builder(
                    itemCount: message.length,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                        child: Column(
                          children: [
                            onlyChat
                                ? ConversationList(
                                    name: "Wine",
                                    messageText: message[index].messageContent,
                                    imageURL: "assets/icons/wine.png",
                                    messageType: message[index].messageType)
                                : Align(
                                    alignment:
                                        message[index].messageType == "model"
                                            ? Alignment.topLeft
                                            : Alignment.topRight,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: (message[index].messageType ==
                                                "model")
                                            ? const Color.fromRGBO(
                                                63, 64, 68, 1)
                                            : Colors.transparent,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    1000
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    12),
                                        child: Text(
                                          textAlign:
                                              message[index].messageType ==
                                                      "model"
                                                  ? TextAlign.left
                                                  : TextAlign.right,
                                          message[index].messageContent,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                            message[index].messageProduct.isEmpty
                                ? Container()
                                : ProductCard(
                                    products: message[index].messageProduct)
                          ],
                        ),
                      );
                    })),
              ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(
                left: onlyChat ? 10 : MediaQuery.of(context).size.width / 12,
                bottom: 10,
                top: 10),
            height: 156,
            width: double.infinity,
            child: Column(
              children: [
                _loading
                    ? const SizedBox(
                        height: 36,
                      )
                    : SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: candidateList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8), // 아이템 간격을 30 픽셀로 지정합니다.
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                textcontroller.text = candidateList[index].text;
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: onlyChat
                                          ? 12
                                          : MediaQuery.of(context).size.width >
                                                      1000 &&
                                                  index == 0
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10
                                              : 15),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: onlyChat
                                            ? Colors.grey
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: onlyChat
                                                ? Colors.grey
                                                : Colors.grey.shade700)),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0, // 위 아래 padding 추가
                                    ),
                                    child: Center(
                                      child: Text(
                                        candidateList[index].text,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                Container(
                  height: 12,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width > 1000 && !onlyChat
                              ? MediaQuery.of(context).size.width / 12
                              : MediaQuery.of(context).size.width / 96,
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        onSubmitted: (text) {
                          if (!_loading) {
                            sendMessage(text);
                          }
                        },
                        enabled: !_loading,
                        //textInputAction: TextInputAction.go,
                        cursorColor: Colors.grey,
                        controller: textcontroller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "메세지 보내기",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          filled: true,
                          fillColor: onlyChat
                              ? Colors.grey.shade200
                              : const Color.fromARGB(255, 76, 74, 77),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () {
                              sendMessage(textcontroller.text);
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 40),
                        backgroundColor:
                            _loading ? Colors.grey : const Color(0xFF0288D1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // 모서리를 둥글게 조정
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                        width: onlyChat
                            ? 12
                            : MediaQuery.of(context).size.width > 1000
                                ? MediaQuery.of(context).size.width / 8
                                : MediaQuery.of(context).size.width / 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget BaseUI(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        InkWell(
          onTap: _handleNewChatPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1.2, color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "New chat",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Container(
          width: 224,
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          child: const Image(
            image: AssetImage('assets/images/weblogo.png'),
            fit: BoxFit.cover,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Demo",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 12),
        login ? UserInfoList(userName!, userImg!) : LoginButton(),
        Flexible(child: Container()),
        // InkWell(
        //   onTap: () {
        //     MyFluroRouter.router.navigateTo(context, "/build");
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) => const BuildScreen()),
        //     // );
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 12,
        //       horizontal: 30,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       gradient: const LinearGradient(
        //         colors: [
        //           Color(0xFFE040FB),
        //           Colors.deepPurple,
        //         ],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //     ),
        //     child: const Text(
        //       "Build Chatbot",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16,
        //           fontWeight: FontWeight.w600),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 12,
        // ),
        InkWell(
          onTap: () {
            MyFluroRouter.router.navigateTo(context, "/build");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const BuildScreen()),
            // );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [
                  Colors.indigo,
                  Colors.cyan,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              "Build Chatbot",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "© 2023 audery.AI. All Rights Reserved.",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget LoginButton() {
    return Container(
      child: Column(
        children: [
          // const Text("Get Started",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //     )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  MyFluroRouter.router.navigateTo(context, "/login");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const LoginScreen()),
                  // );
                },
                onHover: (value) {
                  setState(() {
                    isLoginButtonHovered = value;
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                        color: isLoginButtonHovered
                            ? const Color.fromARGB(255, 49, 85, 214) // 변경된 색상
                            : Colors.indigo,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text("Log in",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600))),
              ),
              InkWell(
                onTap: () {
                  MyFluroRouter.router.navigateTo(context, "/login");

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const LoginScreen()),
                  // );
                },
                onHover: (value) {
                  setState(() {
                    isSignUpButtonHovered = value;
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                        color: isSignUpButtonHovered
                            ? const Color.fromARGB(255, 49, 85, 214)
                            : Colors.indigo,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text("Sign up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600))),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget UserInfoList(String name, String userImage) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        iconColor: Colors.white70,
        initiallyExpanded: false,
        trailing: const Icon(Icons.expand_more_rounded),
        onExpansionChanged: (exapnsion) {
          setState(() {
            isExpansion = exapnsion;
          });
        },
        leading: Container(
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle, // BoxShape를 원으로 설정
            // 추가적인 스타일링을 원하는 경우 여기에 추가 가능
          ),
          child: ClipOval(
            child: Image.network(
              userImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 46, 50, 52)),
                child: Column(
                  children: [
                    MyChatbot("Wine"),
                    // MyChatbot("Winininiinin"),
                    LogOutBttn()
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget MyChatbot(String name) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ResultScreen(chatbot_name: "Wine")),
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8.0),
          child: Row(
            children: [
              const Image(
                image: AssetImage('assets/icons/wine.png'),
                fit: BoxFit.contain,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8), // 이미지와 텍스트 사이 간격
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis, // 텍스트가 길면 자동으로 줄바꿈
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LogOutBttn() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.white10), // 위쪽에 테두리 추가
          // 나머지 방향에는 테두리가 없음
        ),
      ),
      child: InkWell(
        onTap: () async {
          var cookie = Cookie.create();
          cookie.remove('access_token');
          cookie.remove('refresh_token');
          setState(() {
            login = false;
            _handleNewChatPressed();
          });
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.logout, size: 28, color: Colors.white),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, // 텍스트가 길면 자동으로 줄바꿈
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //State 끝
}
