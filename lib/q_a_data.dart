import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({
    super.key,
  });

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  List<Widget> qaContainers = []; // Q&A 컨테이너들을 저장할 리스트

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 기존 Q&A 컨테이너들
        Column(children: qaContainers),
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            child: const Icon(
              Icons.add_circle_rounded,
              color: Colors.teal,
              size: 36,
            ),
            onTap: () {
              // 추가 버튼을 눌렀을 때 새로운 Q&A 컨테이너를 생성하여 리스트에 추가
              setState(() {
                qaContainers.add(QAContainer(onDelete: () {
                  // 취소 버튼을 눌렀을 때 해당 Q&A 컨테이너를 삭제
                  setState(() {
                    qaContainers.removeAt(qaContainers.length - 1);
                  });
                }));
              });
            },
          ),
        )
      ],
    );
  }
}

class QAContainer extends StatelessWidget {
  final VoidCallback onDelete;

  const QAContainer({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("자주 묻는 질문/답변 등 추가로 등록하고 싶은 Q & A를 적어주세요",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(
              height: 24,
            ),
            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintText: "질문",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                focusColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
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
            const SizedBox(
              height: 12,
            ),
            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintText: "답변",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                // filled: true,
                // fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
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
            const SizedBox(height: 12),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            iconSize: 24,
            onPressed: onDelete, // 취소 버튼 누를 때 삭제 함수 호출
            icon: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.cancel_outlined, color: Colors.grey),
            ),
          ),
        )
      ]),
    );
  }
}
