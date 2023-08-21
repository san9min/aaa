import 'package:chatresume/model/drag_schema_list.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

class DataCard extends StatefulWidget {
  const DataCard({super.key});

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  List<dynamic> data = [];
  List<List<DraggableList>> schemaDragable = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = [
      {
        "Title": "Product",
        "description":
            "와인을 판매하는 페이지입니다. 해당 페이지에는 와인 상품에 대한 이름, 가격, 와인의 특징(바디감, 산도, 알코올 등), 평점 등이 포함되어 있습니다.",
        "webs_num": 253,
        "image": "assets/1.png",
        "urls": [
          "https://www.winenara.com/shop/product/product_view?product_cd=04D351",
          "https://www.winenara.com/shop/product/product_view?product_cd=02A72",
          "https://www.winenara.com/shop/product/product_view?product_cd=14A240",
          "https://www.winenara.com/shop/product/product_view?product_cd=03P926",
          "https://www.winenara.com/shop/product/product_view?product_cd=04E098"
        ],
        "schema": {
          "Product": [
            "상품 이름",
            "가격",
            "와인의 특징",
          ],
          "Purchase": ["예약", "구매 링크"],
          "qwerty": ["반품", "환불스", "ㅓㅓㅓㅓ"]
        }
      },
      {
        "Title": "Product List",
        "description":
            "와인 목록이 나열되어 있는 페이지입니다. 여러 와인에 대한 이름, 가격, 설명, 이미지가 나열되어 있습니다.",
        "webs_num": 79,
        "image": "assets/2.png",
        "urls": [
          "https://www.winenara.com/shop/product/product_lists?sh_category1_cd=10000&sh_category2_cd=10100&sh_category3_cd=10108",
          "https://www.winenara.com/shop/product/product_lists?sh_category1_cd=10000&sh_category2_cd=10100&sh_category3_cd=10105",
          "https://www.winenara.com/shop/product/product_lists?sh_category1_cd=10000&sh_category2_cd=10100&page=22",
          "https://www.winenara.com/shop/product/product_lists?sh_category1_cd=10000&sh_category2_cd=10100&sh_category3_cd=10101",
          "https://www.winenara.com/shop/product/product_lists?sh_category1_cd=20000&sh_category2_cd=20200&sh_category3_cd=20201&page=1"
        ],
        "schema": {
          "Product": ["상품 이름", "가격", "설명", "이미지 링크"]
        }
      },
      {
        "Title": "F&B Notice",
        "description": "해당 페이지에서는 와인나라의 다양한 와인들을 글라스와 바틀로 선보이는 F&B 매장을 소개합니다.",
        "webs_num": 1,
        "image": "assets/3.png",
        "schema": {},
        "urls": ["https://www.winenara.com/shop/company/fnb"]
      },
      {
        "Title": "Notice",
        "description": "공지사항에 대한 페이지입니다.",
        "webs_num": 17,
        "image": "assets/4.png",
        "schema": {},
        "urls": [
          "https://www.winenara.com/shop/cs/notice_view?no=653",
          "https://www.winenara.com/shop/cs/notice_view?no=658",
          "https://www.winenara.com/shop/cs/notice_view?no=1021",
          "https://www.winenara.com/shop/cs/notice_view?no=1061",
          "https://www.winenara.com/shop/cs/notice_view?no=652"
        ]
      },
      {
        "Title": "Promotion",
        "description": "이벤트 홍보에 대한 페이지입니다.",
        "webs_num": 11,
        "image": "assets/5.png",
        "schema": {},
        "urls": [
          "https://www.winenara.com/shop/event/event_view?no=273",
          "https://www.winenara.com/shop/event/event_view?no=275",
          "https://www.winenara.com/shop/event/event_view?no=279",
          "https://www.winenara.com/shop/event/event_view?no=277",
          "https://www.winenara.com/shop/event/event_view?no=274"
        ]
      },
      {
        "Title": "Cart",
        "description": "장바구니 페이지입니다.",
        "webs_num": 1,
        "image": "assets/6.png",
        "urls": ["https://www.winenara.com/shop/cart/cart_lists"],
        "schema": {
          "Product": ["상품 이름", "가격", "상품 링크"],
          "hihi": ["비비", "오오", "갸갹 링크"]
        }
      },
      {
        "Title": "Law Agreement",
        "description": "회원 가입 시 이용약관 동의를 받기 위한 페이지입니다.",
        "webs_num": 1,
        "image": "assets/7.png",
        "schema": {},
        "urls": ["https://www.winenara.com/shop/member/join/law_agreement"]
      }
    ];
    List<dynamic> schemaList = data.map((item) => item['schema']).toList();

    for (int i = 0; i < data.length; i++) {
      if (schemaList[i].isEmpty) {
        schemaDragable.add([const DraggableList(header: "", items: [])]);
        continue;
      } else {
        final keys = schemaList[i].keys.toList();
        List<DraggableList> helper = [];
        for (int j = 0; j < keys.length; j++) {
          String title = keys[j];
          List<String> itemsString = schemaList[i][title];
          List<DraggableListItem> items = [];

          for (int k = 0; k < itemsString.length; k++) {
            items.add(DraggableListItem(
                title: itemsString[k],
                key: title + k.toString() + itemsString[k]));
          }
          helper.add(DraggableList(header: title, items: items));
        }
        schemaDragable.add(helper);
      }
    }
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    int numItem = data.length;

    return Center(
      child: SelectableRegion(
        selectionControls: materialTextSelectionControls,
        focusNode: _focusNode,
        child: GridView.builder(
          shrinkWrap: true,
          // padding: EdgeInsets.symmetric(
          //     vertical: MediaQuery.of(context).size.height / 24,
          //     horizontal: MediaQuery.of(context).size.width / 12),
          itemCount: numItem,

          itemBuilder: (ctx, i) {
            return i == numItem - 1
                ? Container(
                    height: 480,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Colors.cyan)),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_box_outlined, color: Colors.cyan),
                        Text(
                          '개별 링크 추가하기',
                          style: TextStyle(color: Colors.cyan),
                        )
                      ],
                    )),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        color: Colors.cyan,
                      ),
                      color: const Color.fromARGB(225, 0, 0, 0), // 카드 배경색 변경
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.cyan,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: WebClassCard(
                      data_i: data[i],
                      schema: schemaDragable[i],
                      onDelete: () {
                        setState(() {
                          data.removeAt(i);
                        });
                      },
                    ));
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 2 : 1,
            childAspectRatio: .5,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: MediaQuery.of(context).size.height / 1.5,
          ),
        ),
      ),
    );
  }
}

class WebClassCard extends StatefulWidget {
  const WebClassCard({
    Key? key,
    required this.data_i,
    required this.schema,
    required this.onDelete,
  }) : super(key: key);
  final dynamic data_i;
  final Function() onDelete;
  final List<DraggableList> schema;

  @override
  State<WebClassCard> createState() => _WebClassCardState();
}

class _WebClassCardState extends State<WebClassCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lists = widget.schema.map(buildList).toList();
  }

  late List<DragAndDropList> lists;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image(
                  image: AssetImage(widget.data_i['image']),
                  height: 96,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.data_i['Title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: IconButton(
                        onPressed: () {},
                        iconSize: 18,
                        color: Colors.grey,
                        icon: const Icon(Icons.settings),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.data_i['description'],
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  child: ExpansionTile(
                    collapsedIconColor: Colors.cyan,
                    title: Text(
                      "포함된 링크 : ${widget.data_i['urls'].length} 개",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade50,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: 256,
                              // constraints: const BoxConstraints(
                              //   maxWidth:
                              //       256, // Adjust the maximum width as needed
                              // ),
                              child: Text(
                                "url",
                                overflow: TextOverflow
                                    .ellipsis, // Handle overflow with ellipsis
                                maxLines:
                                    null, // Limit the number of lines displayed
                                style: TextStyle(
                                    color: Colors.grey.shade100, fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: 64,
                              decoration: BoxDecoration(
                                //  borderRadius: BorderRadius.circular(8),
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "개수",
                                  style: TextStyle(
                                      color: Colors.grey.shade100,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text("Delete",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          widget.data_i['urls'].length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              //  borderRadius: BorderRadius.circular(8),
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 256,
                                    constraints: const BoxConstraints(
                                      maxWidth:
                                          256, // Adjust the maximum width as needed
                                    ),
                                    child: Text(
                                      widget.data_i['urls'][index],
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow with ellipsis
                                      maxLines:
                                          2, // Limit the number of lines displayed
                                      style: TextStyle(
                                          color: Colors.grey.shade100,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: 64,
                                    decoration: BoxDecoration(
                                      //  borderRadius: BorderRadius.circular(8),
                                      border: Border.symmetric(
                                        vertical: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "1561개",
                                        style: TextStyle(
                                            color: Colors.grey.shade100,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.data_i['urls']
                                                .removeAt(index);
                                          });
                                        },
                                        child: const Icon(Icons.delete,
                                            size: 18, color: Colors.red))),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:
                    lists.isEmpty || lists[0].header!.key == const ValueKey("")
                        ? 60
                        : 224,
                child: DragAndDropLists(
                  contentsWhenEmpty: const Text(""),
                  lastItemTargetHeight: 8,
                  addLastItemTargetHeightToTop: true,
                  lastListTargetSize: 40,
                  // listInnerDecoration: BoxDecoration(
                  //   color: Theme.of(context).canvasColor,
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  children: lists,
                  itemDivider: const Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  itemDecorationWhileDragging: BoxDecoration(
                    color: Colors.cyan.shade700,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),

                  listDragHandle: buildDragHandle(isList: true),
                  itemDragHandle: buildDragHandle(),
                  onItemReorder: onReorderListItem,
                  onListReorder: onReorderList,
                ),
              )

              // data[i]['schema'].isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: Text(
              //           data[i]['schema'].toString().substring(
              //               1,
              //               data[i]['schema']
              //                       .toString()
              //                       .length -
              //                   1),
              //           style: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 12,
              //               color:
              //                   Colors.cyan //Color(0xFFE040FB),
              //               ),
              //         ),
              //       )
              ,
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    const color = Colors.blueGrey;

    return isList
        ? DragHandle(
            child: Container(),
          )
        : DragHandle(
            verticalAlignment: verticalAlignment,
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.menu, color: color, size: 24),
            ),
          );
  }

  void onRemove(int listIndex) {
    setState(() {
      lists.removeAt(listIndex);
    });
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        contentsWhenEmpty: const Text(""),
        decoration: const BoxDecoration(color: Colors.transparent),
        rightSide: const SizedBox(
          width: 12,
        ),
        leftSide: const SizedBox(
          width: 12,
        ),
        header: Container(
          key: ValueKey<String>(list.header),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text(
                list.header,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.cyan),
              ),
              const SizedBox(
                width: 8,
              ),
              if (list.header != "")
                InkWell(
                  onTap: () {
                    setState(() {
                      lists.removeWhere((element) =>
                          element.header!.key == ValueKey(list.header));

                      //인덱스 업뎃해야되네
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_forever,
                        size: 18,
                        color: Colors.red,
                      ),
                      Text("Delete",
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                )
            ],
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: Row(
                      key: ValueKey(list.header + item.title),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.cyan,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        InkWell(
                            onTap: () {
                              // print(lists[0].children[0]);
                              // lists.map((lst)=>

                              // lst.children.removeWhere((item) => item.key == lst)
                              // );
                            },
                            child: const Icon(Icons.delete))
                      ]),
                ))
            .toList(),
      );
}
