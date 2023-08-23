import 'package:chatresume/chat.dart';
import 'package:chatresume/model/user_candidates.dart';
import 'package:flutter/material.dart';
import 'package:chatresume/widget/conversation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:chatresume/main.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.chatbot_name});
  final chatbot_name;
  @override
  State<ResultScreen> createState() => _ResultScreenState(chatbot_name);
}

class _ResultScreenState extends State<ResultScreen> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);
  PageController dataPageController = PageController(initialPage: 0);
  String chatbot_name;
  _ResultScreenState(this.chatbot_name);
  TextEditingController initial_mssg = TextEditingController();
  TextEditingController chatbot_name_controller = TextEditingController();
  List<Candidate> candidateList = [
    Candidate(text: "제품/서비스 설명 해주세요!"),
    Candidate(text: "무엇을 하는 회사인가요?"),
    Candidate(text: "가격이 어떻게 되나요?"),
  ];
  List<TextEditingController> candidate_text_controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  int pageIndex = 0;
  int dataPageIndex = 0;
  PlatformFile? _pickedFile;
  bool copy = false;
  int select_i = 0;
  Color ui_theme_color = Colors.blue; // const Color(0xFF0288D1);

  final List<Color> themeColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
      });
    } else {
      print('No file selected');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.red.shade800,
                size: 48,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("삭제하기"),
              ),
            ],
          ),
          content: const Text("챗봇을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () {
                // 삭제 로직 실행

                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.shade800),
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade400,
                ),
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("저장이 완료되었습니다."),
          icon: const Icon(
            Icons.check,
            color: Colors.teal,
            size: 48,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSetDomainDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("도메인 설정"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("각 도메인을 새 줄에 입력합니다.",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 3,
                child: const TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    hintText: "도메인 입력",
                    contentPadding: EdgeInsets.all(18.0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade500),
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  select_i = 0;
                });
                _showEmbedDialog(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blueGrey,
                ),
                child: const Text(
                  '도메인 설정',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEmbedDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text("웹사이트에 퍼가기"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("웹사이트 어디에서나 챗봇을 추가하려면 다음 iframe을 HTML 코드에 추가하세요.",
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          select_i = 1;
                          //Clipboard.setData(const ClipboardData(text: "copy ID"));
                        });
                      },
                      child: Stack(children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text('''
<iframe
src="https://www.audreyai.kr/chatbot-iframe/copyid"
width="100%"
style="height: 100%; min-height: 700px"
frameborder="0"
></iframe>                 
''', textAlign: TextAlign.left)),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(
                            select_i == 1 ? Icons.check : Icons.copy_rounded,
                          ),
                        )
                      ]),
                    ),
                    const SizedBox(height: 12),
                    Text("웹사이트 오른쪽 하단에 말풍선을 추가하려면 다음 스크립트 태그를 HTML에 추가합니다.",
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          select_i = 2;
                        });
                      },
                      child: Stack(children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text('''
<script>
window.chatbaseConfig = {
chatbotId: "-copyid",
}
</script>
<script
src="https://www.audreyai.kr/embed.min.js"
id="-copyid"
defer>
</script>                    
''', textAlign: TextAlign.left)),
                        Positioned(
                            top: 12,
                            right: 12,
                            child: Icon(
                              select_i == 2 ? Icons.check : Icons.copy_rounded,
                            ))
                      ]),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    dataPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor: const Color.fromRGBO(30, 34, 42, 1),
            appBar: (MediaQuery.of(context).size.width < 600)
                ? AppBar(
                    title: InkWell(
                      onTap: () {
                        MyFluroRouter.router.navigateTo(context, "/");
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Chat()),
                        //   (route) => false,
                        // );
                      },
                      child: const Image(
                        height: 32,
                        image: AssetImage('assets/images/weblogo.png'),
                        fit: BoxFit.contain,
                      ),
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
              child: pageButtonLayout(),
            ),
            body: Row(
              children: [
                MediaQuery.of(context).size.width > 600
                    ? Container(
                        width: 256,
                        color: const Color.fromARGB(255, 36, 36, 36),
                        child: pageButtonLayout())
                    : Container(),
                Expanded(child: mainPageView()),
              ],
            )));
  }

  // List<Widget> headerSliverBuilder(
  //     BuildContext context, bool innerBoxIsScrolled) {
  //   return <Widget>[
  //     SliverOverlapAbsorber(
  //       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //       sliver: SliverPersistentHeader(
  //         pinned: true,
  //         delegate: SliverHeaderDelegateCS(
  //           minHeight: sliverMinHeight,
  //           maxHeight: sliverMaxHeight,
  //           minChild: minTopChild(),
  //           maxChild: topChild(),
  //         ),
  //       ),
  //     ),
  //   ];
  // }

  // Widget minTopChild() {
  //   return Column(
  //     children: <Widget>[
  //       pageButtonLayout(),
  //     ],
  //   );
  // }

  Widget topChild() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 46, 50, 52),
            child: Text(
              chatbot_name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12),
          child: pageButtonLayout(),
        ),
      ],
    );
  }

  Widget pageButtonLayout() {
    double btnHeight = MediaQuery.of(context).size.height > 500
        ? MediaQuery.of(context).size.height / 12
        : 50;
    return SizedBox(
      // decoration: const BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.blueGrey, width: 1))),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 18),
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
              height: 36,
              image: AssetImage('assets/images/weblogo.png'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
              height: btnHeight,
              child: pageButton("설정", 0, Icons.settings_outlined)),
          SizedBox(
              height: btnHeight,
              child: pageButton("채팅 기록보기", 1, Icons.dashboard_outlined)),
          SizedBox(
              height: btnHeight,
              child: pageButton("DataBase 관리", 2, Icons.edit_document)),
          SizedBox(
              height: btnHeight,
              child: pageButton("내보내기", 3, Icons.exit_to_app_sharp)),
          SizedBox(
              height: btnHeight,
              child: pageButton("테스트", 4, Icons.chat_outlined)),
          SizedBox(
              height: btnHeight,
              child: pageButton("삭제하기", 5, Icons.delete_outlined)),
          Flexible(child: Container()),
          const Text(
            "© 2023 audery.AI. All Rights Reserved.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget pageButton(String title, int page, IconData iconData) {
    final fontColor = pageIndex == page ? Colors.cyan : Colors.grey.shade700;
    final lineColor = pageIndex == page ? Colors.teal : Colors.transparent;

    return InkWell(
      splashColor: const Color(0xFF204D7E),
      onTap: () {
        if (page == 5) {
          _showDeleteConfirmationDialog(context);
        } else {
          pageBtnOnTap(page);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 1,
                color: lineColor,
              ),
              const SizedBox(width: 32),
              Icon(iconData, size: 24, color: fontColor),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                    color: fontColor,
                    fontSize: 14,
                    fontWeight:
                        pageIndex == page ? FontWeight.bold : FontWeight.w100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pageBtnOnTap(int page) {
    setState(() {
      pageIndex = page;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.bounceIn);
    });
  }

  Widget mainPageView() {
    double textfieldWidth = MediaQuery.of(context).size.width > 1000
        ? MediaQuery.of(context).size.width / 2
        : double.infinity;
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width / 2.5
                      : MediaQuery.of(context).size.width / 1.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "설정",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width > 1000
                                ? 36.0
                                : 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 48),
                            const Text(
                              "챗봇 프로필 사진",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: _pickFiles,
                                    child: Container(
                                      height: 128,
                                      width: 128,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              64.0), // Half of height and width to create a perfect circle
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: chatbot_name == "Wine"
                                          ? ClipOval(
                                              child: Image.asset(
                                                  'assets/icons/wine.png',
                                                  fit: BoxFit.cover))
                                          : ClipOval(
                                              child: _pickedFile == null
                                                  ? Image.asset(
                                                      'assets/images/logo.png',
                                                      fit: BoxFit.cover)
                                                  : Image.memory(
                                                      _pickedFile!.bytes!,
                                                      fit: BoxFit.contain),
                                            ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "챗봇 ID",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: textfieldWidth,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("copy ID",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                            copy
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    Icons.copy_rounded,
                                                    color: Colors.white,
                                                  ),
                                          ],
                                        ),
                                        onTap: () {
                                          Clipboard.setData(const ClipboardData(
                                              text: "copy ID"));
                                          setState(() {
                                            copy = true;
                                          });
                                        },
                                      )),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "챗봇 이름",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: textfieldWidth,
                                  child: TextField(
                                    controller: chatbot_name_controller,
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: chatbot_name,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      focusColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        48),
                                const Text("테마색",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: ListView.separated(
                                      itemCount: themeColors.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                            width: 8); // 각 아이템 사이에 간격 추가
                                      },
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                ui_theme_color =
                                                    themeColors[index];
                                              });
                                            },
                                            child: ColorCircle(
                                                color: themeColors[index],
                                                current: ui_theme_color));
                                      },
                                    ),
                                  ),
                                ),
                                const Text(
                                  "초기 메시지",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: textfieldWidth,
                                  child: TextField(
                                    controller: initial_mssg,
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      focusColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "추천 메세지",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: textfieldWidth,
                                  child: TextField(
                                    controller: candidate_text_controller[0],
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: candidateList[0].text,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      focusColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: textfieldWidth,
                                  child: TextField(
                                    controller: candidate_text_controller[1],
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: candidateList[1].text,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      focusColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: textfieldWidth,
                                  child: TextField(
                                    controller: candidate_text_controller[2],
                                    cursorColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: candidateList[2].text,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      focusColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 12 > 96
                                        ? MediaQuery.of(context).size.width / 12
                                        : 96,
                                height:
                                    48, // Set the desired height for the button
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.indigo,
                                      Colors.cyan,
                                    ], // 그라데이션 색상 설정
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      chatbot_name =
                                          chatbot_name_controller.text;
                                      candidateList = [];
                                      for (final candidate_control
                                          in candidate_text_controller) {
                                        candidateList.add(Candidate(
                                            text: candidate_control.text));
                                      }
                                    });
                                    _showSaveConfirmationDialog(context);
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "저장",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 12
                                              : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MediaQuery.of(context).size.width > 1000
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Preview",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white)),
                          const SizedBox(height: 24),
                          Container(
                            height: MediaQuery.of(context).size.height / 1.4,
                            width: MediaQuery.of(context).size.width / 3.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(children: [
                              Column(children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                        child: _pickedFile == null
                                            ? Image.asset(
                                                'assets/images/logo.png',
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover)
                                            : Image.memory(_pickedFile!.bytes!,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.contain),
                                      ),
                                      Text(chatbot_name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                              fontSize: 18)),
                                    ]),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                if (initial_mssg.text != "")
                                  ConversationList(
                                      name: chatbot_name,
                                      messageText: initial_mssg.text,
                                      imageURL: 'assets/images/logo.png',
                                      messageType: "model"),
                                Flexible(child: Container()),
                                Column(
                                  children: [
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Center(
                                      child: Container(
                                        color: Colors.white,
                                        child: const Text(
                                            "Powered by @audrey.AI",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF002855),
                                                fontSize: 14)),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                )
                              ]),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  height: 156,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 42,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: candidateList.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                  width:
                                                      8), // 아이템 간격을 30 픽셀로 지정합니다.
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                const SizedBox(width: 8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300)),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12.0,
                                                    vertical:
                                                        4.0, // 위 아래 padding 추가
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      candidateList[index].text,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                hintText: "메세지 보내기",
                                                hintStyle: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade500,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade500,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(40, 40),
                                              backgroundColor: ui_theme_color,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // 모서리를 둥글게 조정
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: ui_theme_color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.chat_bubble_outline,
                                        size: 36, color: Colors.white)),
                              ])
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        )),
        //Page2
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 5),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: const Text(
                " 아직 아무도 말을 걸어주지 않았습니다",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        )),
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 24),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "데이터",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width > 1000 ? 36.0 : 0,
                      left: MediaQuery.of(context).size.width > 1000 ? 36.0 : 0,
                      right:
                          MediaQuery.of(context).size.width > 1000 ? 36.0 : 0),
                  child: SizedBox(
                    height: 48,
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.white,
                    //       width: 2,
                    //     ),
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dataPageIndex = 0;
                                    dataPageController.animateToPage(
                                        dataPageIndex,
                                        duration:
                                            const Duration(milliseconds: 1),
                                        curve: Curves.easeInSine);
                                  });
                                },
                                child: Center(
                                    child: Text("Website",
                                        style: TextStyle(
                                          color: dataPageIndex == 0
                                              ? Colors.cyan
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )))),
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dataPageIndex = 1;
                                    dataPageController.animateToPage(
                                        dataPageIndex,
                                        duration:
                                            const Duration(milliseconds: 1),
                                        curve: Curves.easeInSine);
                                  });
                                },
                                child: Center(
                                    child: Text("Files",
                                        style: TextStyle(
                                          color: dataPageIndex == 1
                                              ? Colors.cyan
                                              : Colors.grey,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                        )))),
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dataPageIndex = 2;
                                    dataPageController.animateToPage(
                                        dataPageIndex,
                                        duration:
                                            const Duration(milliseconds: 1),
                                        curve: Curves.easeInSine);
                                  });
                                },
                                child: Center(
                                    child: Text("Q&A",
                                        style: TextStyle(
                                          color: dataPageIndex == 2
                                              ? Colors.cyan
                                              : Colors.grey,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                        )))),
                          ),
                        ]),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.width / 1.2,
                width: MediaQuery.of(context).size.width / 1.2,
                child: PageView(
                  controller: dataPageController,
                  children: [
                    pageItem(Column(
                      children: [
                        Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: MediaQuery.of(context).size.height / 48,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Website",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        //const DataCard(),
                      ],
                    )),
                    pageItem(
                      Column(
                        children: [
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: MediaQuery.of(context).size.height / 48,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Files",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    pageItem(
                      Column(
                        children: [
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            height: MediaQuery.of(context).size.height / 48,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Q&A",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onPageChanged: (index) =>
                      setState(() => dataPageIndex = index),
                ),
              )
              // const Text(
              //   "Q & A Data",
              //   textAlign: TextAlign.left,
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // Divider(
              //   color: Colors.grey,
              //   thickness: 1,
              //   height: MediaQuery.of(context).size.height / 48,
              // ),

              // SizedBox(height: MediaQuery.of(context).size.height / 48),
              // //const Example(),
              // const SizedBox(
              //   height: 12,
              // ),
              // const Text(
              //   "WebSite Data",
              //   textAlign: TextAlign.left,
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // Divider(
              //   color: Colors.grey,
              //   thickness: 1,
              //   height: MediaQuery.of(context).size.height / 48,
              // ),

              ,
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 12 > 96
                      ? MediaQuery.of(context).size.width / 12
                      : 96,
                  height: 48, // Set the desired height for the button
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.indigo,
                        Colors.cyan,
                      ], // 그라데이션 색상 설정
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "저장",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 12 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        )),
        pageItem(
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 24,
                  horizontal: MediaQuery.of(context).size.width / 24),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    "내보내기",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        _showSetDomainDialog(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width > 900
                            ? MediaQuery.of(context).size.width / 3
                            : 300,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              ClipOval(
                                child: Image(
                                  height: 32,
                                  image: AssetImage('assets/icons/globe.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Text(
                                "내 웹사이트에 추가하기",
                                style: TextStyle(color: Colors.white70),
                              )
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width > 900
                            ? MediaQuery.of(context).size.width / 3
                            : 300,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              ClipOval(
                                child: Image(
                                  height: 32,
                                  image:
                                      AssetImage('assets/icons/kakao_ch.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Text(
                                "카카오 채널에 추가하기",
                                style: TextStyle(color: Colors.white70),
                              )
                            ]),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        pageItem(Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 24,
                horizontal: MediaQuery.of(context).size.width / 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "테스트",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width > 1000 ? 36.0 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "State",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 96,
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade400)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh,
                                      color: Colors.grey.shade400),
                                  Text(
                                    " Training",
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                ],
                              )),
                          const SizedBox(width: 12),
                          Container(
                              width: 96,
                              height: 42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.lightGreen)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check, color: Colors.lightGreen),
                                  Text(
                                    " Trained",
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width > 1000
                              ? MediaQuery.of(context).size.width / 3
                              : MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 20,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Chat(
                              onlyChat: true,
                              pickedFile: _pickedFile,
                              chatbot_name: chatbot_name),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))),
      ],
      onPageChanged: (index) => setState(() => pageIndex = index),
    );
  }

  Widget pageItem(Widget child) {
    double statusHeight = MediaQuery.of(context).padding.top;
    double height = MediaQuery.of(context).size.height;
    double minHeight = height - statusHeight; //- sliverMinHeight;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        child: child,
      ),
    );
  }
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final Color current;

  const ColorCircle({super.key, required this.color, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
              width: 2,
              color: color == current ? Colors.white70 : Colors.transparent)),
    );
  }
}
