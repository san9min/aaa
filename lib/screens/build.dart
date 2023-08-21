import 'package:chatresume/main.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

class BuildScreen extends StatefulWidget {
  const BuildScreen({super.key});

  @override
  State<BuildScreen> createState() => _BuildScreenState();
}

class _BuildScreenState extends State<BuildScreen>
    with SingleTickerProviderStateMixin {
  PlatformFile? _pickedFile;
  bool _dragging = false;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);
  bool creating = false;

  final double sliverMinHeight = 80.0, sliverMaxHeight = 140.0;
  int pageIndex = 0;
  double percent = 0.0; // 초기값 설정
  late AnimationController _controller;
  List<QnaContainer> qnaContainers = [];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 10초 동안 애니메이션 실행
    )..addListener(() {
        setState(() {
          percent = _controller.value;
        });
      });
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.single;
      });
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(30, 34, 42, 1),
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
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
          backgroundColor: const Color(0x44000000),
          elevation: 0,
        ),
        body:
            //  NestedScrollView(
            //   controller: scrollController,
            //   headerSliverBuilder: headerSliverBuilder,
            //   body: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         Container(
            //           height: MediaQuery.of(context).size.height / 1.5,
            //           margin: EdgeInsets.only(top: sliverMinHeight),
            //           child: dataPageView(),
            //         ),
            //         CreateButton(),
            //       ],
            //     ),
            //   ),
            // ),

            FooterView(
          footer: Footer(
            padding: const EdgeInsets.all(5.0),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Copyright © 2023 audrey. AI. All Rights Reserved.',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Color(0xFF162A49)),
                  ),
                ]),
          ),
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width / 12
                        : 12,
                    vertical: 24),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Data Sources",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 12),
                      child: pageButtonLayout(),
                    ),
                    SizedBox(
                      height: percent == 1.0 || qnaContainers.isNotEmpty
                          ? MediaQuery.of(context).size.height / 1
                          : MediaQuery.of(context).size.height / 2,
                      child: dataPageView(),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CreateButton(),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ))),
          ],
        ));
  }

  Widget CreateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 48,
          horizontal: MediaQuery.of(context).size.width / 8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "포함된 데이터",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
              "12 Links (68,254 detected chars) | 1 File (89,060 chars) | 2 Q&A (200 chars)",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
          const SizedBox(height: 12),
          Center(
            child: InkWell(
              onTap: () {
                MyFluroRouter.router.navigateTo(context, "/manage");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ResultScreen(
                //             chatbot_name: "My Chatbot",
                //           )),
                //);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 64,
                  horizontal: MediaQuery.of(context).size.width / 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.indigo,
                      Colors.cyan,
                    ], // 그라데이션 색상 설정
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  "Create Chatbot",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  //

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

  // Widget topChild() {
  //   return Column(
  //     children: <Widget>[
  //       Expanded(
  //         child: Container(
  //           alignment: Alignment.center,
  //           color: const Color.fromARGB(255, 46, 50, 52),
  //           child: const Text(
  //             "Data Sources",
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.symmetric(
  //             horizontal: MediaQuery.of(context).size.width / 12),
  //         child: pageButtonLayout(),
  //       ),
  //     ],
  //   );
  // }

  //

  Widget pageButtonLayout() {
    return SizedBox(
      // decoration: const BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.blueGrey, width: 1))),
      height: sliverMinHeight / 2,
      child: Row(
        children: <Widget>[
          Expanded(child: pageButton("Website", 0)),
          Expanded(child: pageButton("Files", 1)),
          Expanded(child: pageButton("Q&A", 2)),
        ],
      ),
    );
  }

  Widget pageButton(String title, int page) {
    final fontColor = pageIndex == page ? Colors.cyan : const Color(0xFF9E9E9E);
    final lineColor = pageIndex == page ? Colors.cyan : Colors.transparent;

    return InkWell(
      splashColor: const Color(0xFF204D7E),
      onTap: () => pageBtnOnTap(page),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    color: fontColor,
                    fontWeight: pageIndex == page
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
          ),
          Container(
            height: 1,
            color: lineColor,
          ),
        ],
      ),
    );
  }

  pageBtnOnTap(int page) {
    setState(() {
      pageIndex = page;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCirc);
    });
  }

  Widget dataPageView() {
    return PageView(
      physics: const RangeMaintainingScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 12),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 48,
                  ),
                  const Center(
                    child: Text(
                      "Website Data Source",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "홈페이지(메인페이지)의 주소를 넣어주세요 \n이렇게 하면 url로 시작하는 모든 링크(웹사이트의 파일 제외)가 크롤링됩니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 1000
                          ? MediaQuery.of(context).size.width / 10
                          : 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height:
                                42, // Set the desired height for both TextField and Button
                            child: TextField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                hintText: "https://example.com",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(8.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                12), // Adjust the space between the text field and the button
                        InkWell(
                          onTap: () {
                            setState(() {
                              creating = true;
                            });
                            _controller.forward(); // 애니메이션 시작
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 7,
                            height: 42, // Set the desired height for the button
                            decoration: BoxDecoration(
                              color: const Color(
                                  0x44000000), //const Color(0xFF2A364B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text(
                                "가져오기",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  creating && percent != 1.0
                      ? SizedBox(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              Text(percent == 1.0 ? "완료" : "웹사이트 분석중...",
                                  style: TextStyle(
                                      color: percent == 1.0
                                          ? const Color(0xFF00BCD4)
                                          : percent > 0.5
                                              ? Colors.indigo
                                              : const Color(0xFFE040FB),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(
                                "${(100 * percent).toStringAsFixed(1)} %",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: percent == 1.0
                                      ? const Color(0xFF00BCD4)
                                      : percent > 0.5
                                          ? Colors.indigo
                                          : const Color(0xFFE040FB),
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearPercentIndicator(
                                linearGradient: const LinearGradient(
                                  colors: [
                                    //Color(0xFF9575CD),
                                    Color(0xFFE040FB), // #E040FB
                                    //Colors.indigo,
                                    //Color(0xFF64B5F6)
                                    Color(0xFF00BCD4) // #00BCD4
                                  ],
                                  //

                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                padding: EdgeInsets.zero,
                                percent: percent,
                                lineHeight: 24,
                                barRadius: const Radius.circular(8),
                                backgroundColor: Colors.black38,
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  //   const Text("Sitemap",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       )),
                  //   const SizedBox(
                  //     height: 12,
                  //   ),
                  //   Row(
                  //     children: [
                  //       Expanded(
                  //         child: SizedBox(
                  //           height:
                  //               42, // Set the desired height for both TextField and Button
                  //           child: TextField(
                  //             cursorColor: Colors.grey,
                  //             decoration: InputDecoration(
                  //               hintText: "https://example.com/sitemap.xml",
                  //               hintStyle: TextStyle(color: Colors.grey.shade600),
                  //               filled: true,
                  //               fillColor: Colors.white,
                  //               border: const OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                   color: Colors.transparent,
                  //                   width: 1.0,
                  //                 ),
                  //               ),
                  //               focusedBorder: const OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                   color: Colors.transparent,
                  //                   width: 1.0,
                  //                 ),
                  //               ),
                  //               enabledBorder: const OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                   color: Colors.transparent,
                  //                   width: 1.0,
                  //                 ),
                  //               ),
                  //               contentPadding: const EdgeInsets.all(8.0),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //           width:
                  //               12), // Adjust the space between the text field and the button
                  //       GestureDetector(
                  //         onTap: () {
                  //           // Add functionality to the submit button here
                  //           // This function will be called when the button is tapped.
                  //         },
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width / 7,
                  //           height: 42, // Set the desired height for the button
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(4),
                  //             color: const Color(0xFF2A364B),
                  //           ),
                  //           child: const Center(
                  //             child: Padding(
                  //               padding: EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 "올리기",
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //percent == 1.0 ? const DataCard() : Container(),
                ]),
          ),
        )),
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 12),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                const Text(
                  "Upload Files",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  height: 24,
                ),
                (_pickedFile != null)
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.teal),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.shade200,
                        ),
                        height: 200,
                        width: 400,
                        child: ListTile(
                          title: Text(_pickedFile!.name),
                          subtitle: Text('${_pickedFile!.size} bytes'),
                          trailing: const Icon(Icons.delete_outline_rounded),
                          iconColor: Colors.red.shade500,
                          onTap: () {
                            setState(() {
                              _pickedFile = null;
                            });
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: _pickFiles,
                        child: DropTarget(
                          onDragEntered: (detail) {
                            setState(() {
                              _dragging = true;
                            });
                          },
                          onDragExited: (detail) {
                            setState(() {
                              _dragging = false;
                            });
                          },
                          onDragDone: (detail) async {
                            if (detail.files.isNotEmpty) {
                              XFile droppedFile = detail.files.first;
                              int fileSize = await droppedFile.length();
                              PlatformFile file = PlatformFile(
                                name: droppedFile.name,
                                path: droppedFile.path,
                                size: fileSize,
                                bytes: await droppedFile.readAsBytes(),
                              );

                              setState(() {
                                _pickedFile = file;
                                _dragging = false;
                              });
                            }
                          },
                          child: Container(
                            height: 200,
                            width: 400,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: _dragging
                                  ? Colors.green.shade200
                                  : Colors.grey.shade200,
                            ),
                            child: Center(
                              child: _pickedFile == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file_outlined,
                                          color: Colors.grey,
                                          size: 36,
                                        ),
                                        Text(
                                          "파일을 끌어서 놓거나 클릭하여 파일 선택",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        Text(
                                          "지원 파일 형식 : .pdf, .txt, .xlsx",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        )
                                      ],
                                    )
                                  : Text('Selected file: ${_pickedFile!.name}'),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )),
        pageItem(Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 24,
              horizontal: MediaQuery.of(context).size.width / 12),
          child: SingleChildScrollView(
            child: Column(children: [
              const Text(
                "Q & A Data",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text("자주 묻는 질문/답변 등 추가로 등록하고 싶은 Q & A를 적어주세요",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w300)),
              SizedBox(height: MediaQuery.of(context).size.height / 48),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width / 8
                      : 8,
                ),
                child: Column(
                  children: qnaContainers,
                ),
              ),
              Center(
                  child: InkWell(
                      child: const Icon(
                        Icons.add_circle_rounded,
                        color: Colors.teal,
                        size: 36,
                      ),
                      onTap: () {
                        setState(() {
                          qnaContainers.add(QnaContainer(
                            id: qnaContainers.length, // Assign a unique ID
                            onDelete: (id) {
                              setState(() {
                                qnaContainers.removeWhere(
                                    (container) => container.id == id);
                              });
                            },
                          ));
                        });
                      })),
            ]),
          ),
        ))
      ],
      onPageChanged: (index) => setState(() => pageIndex = index),
    );
  }

  Widget pageItem(Widget child) {
    double statusHeight = MediaQuery.of(context).padding.top;
    double height = MediaQuery.of(context).size.height;
    double minHeight = height - statusHeight - sliverMinHeight;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      child: child,
    );
  }
}

class QnaContainer extends StatelessWidget {
  final int id;
  final Function(int) onDelete;

  const QnaContainer({required this.id, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              //color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(16),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add FAQ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: MediaQuery.of(context).size.height / 48,
                ),
                const Text(
                  "질문",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  cursorColor: Colors.grey.shade900,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyan,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "답변",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    maxLines: null,
                    expands: true,

                    cursorColor: Colors.grey.shade900,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      focusColor: Colors.black,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                    //maxLines: null,
                    // cursorColor: Colors.grey.shade900,
                    // decoration: InputDecoration(
                    //   focusColor: Colors.grey.shade900,
                    //   border: OutlineInputBorder(
                    //     borderSide: BorderSide(
                    //       color: Colors.grey.shade900,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(
                    //       color: Colors.grey.shade900,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    //   enabledBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(
                    //       color: Colors.grey.shade900,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    onDelete(id); // Call the onDelete callback with the ID
                  },
                  child: const Icon(Icons.cancel, color: Colors.white),
                ))
          ]),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
