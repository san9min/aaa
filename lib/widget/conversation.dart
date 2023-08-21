import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String messageText;
  final String imageURL;
  final String messageType;
  //final String time;
  //final bool isMessageRead;
  const ConversationList({
    super.key,
    required this.name,
    required this.messageText,
    required this.imageURL,
    required this.messageType,
    //required this.isMessageRead,
    //required this.time
  });

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 10,
        ),
        child: Row(children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.messageType == "model"
                  ? CircleAvatar(
                      backgroundImage: AssetImage(widget.imageURL),
                      maxRadius: 24,
                      backgroundColor: Colors.white70,
                    )
                  : Container(),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Align(
                      alignment: widget.messageType == "model"
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.messageType == "model")
                              Text(
                                widget.name,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: widget.messageType == "model"
                                      ? Colors.grey.shade300
                                      : Colors.cyan),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                widget.messageText,
                                textAlign: widget.messageType == "model"
                                    ? TextAlign.left
                                    : TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: widget.messageType == "model"
                                        ? Colors.black
                                        : Colors.white
                                    // fontWeight: widget.isMessageRead
                                    //     ? FontWeight.bold
                                    //     : FontWeight.normal
                                    ),
                              ),
                            ),
                            if (widget.messageType == "model")
                              InkWell(
                                onTap: () {},
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.manage_accounts_sharp,
                                          size: 18,
                                          color: Colors.cyan,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          "관리자에게 답변 얻기",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ))),
            ],
          )),
        ]));

    // Text(
    //   widget.time,
    //   style: TextStyle(
    //     color: Colors.yellow,
    //     fontSize: 12,
    //     fontWeight:
    //         widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
    //   ),
    // )
  }
}
