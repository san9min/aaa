import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatefulWidget {
  final String products;

  const ProductCard({Key? key, required this.products}) : super(key: key);

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  int _current = 0;
  dynamic _selectedIndex = {};

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    bool isWine = widget.products.contains("description");

    final List<dynamic> products = jsonDecode(widget.products);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  height: 300.0,
                  aspectRatio: 9 / 16,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: products.map((movie) {
                List<String> imgs = [];
                if (!isWine) {
                  final imgUrls = movie['img_url'];
                  imgs = imgUrls.split('https');
                  imgs.removeAt(0);
                }
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          if (_selectedIndex == movie) {
                            _selectedIndex = {};
                          } else {
                            _selectedIndex = movie;
                          }
                        });
                        if (await canLaunchUrl(Uri.parse(movie['url']))) {
                          await launchUrl(
                              Uri.parse(movie['url'])); // 웹 브라우저에서 URL 열기
                        } else {
                          throw "Could not launch ${movie['url']}";
                        }
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: _selectedIndex == movie
                                  ? Border.all(
                                      color: Colors.purple.shade400, width: 3)
                                  : null,
                              boxShadow: _selectedIndex == movie
                                  ? [
                                      BoxShadow(
                                          color: Colors.purple.shade400,
                                          blurRadius: 30,
                                          offset: const Offset(0, 10))
                                    ]
                                  : [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 5))
                                    ]),
                          child: SingleChildScrollView(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth > 600) {
                                  // Large screen: Image on the left, text on the right
                                  return SizedBox(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 256,
                                          width: 448,
                                          margin: const EdgeInsets.only(
                                              top: 12, left: 12),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: isWine
                                              ? Image.network(movie['image'],
                                                  fit: BoxFit.contain)
                                              : GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                  ),
                                                  itemCount: imgs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: Image.network(
                                                          "https${imgs[index]}",
                                                          fit: BoxFit.cover),
                                                    );
                                                  },
                                                ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children:
                                                _getTextWidgets(movie, isWine),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  // Small screen: Image on top, text on the bottom
                                  return Column(
                                    children: [
                                      Container(
                                        height: 120,
                                        margin: const EdgeInsets.only(top: 10),
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: isWine
                                            ? Image.network(movie['image'],
                                                fit: BoxFit.cover)
                                            : GridView.builder(
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                ),
                                                itemCount: imgs.length,
                                                itemBuilder: (context, index) {
                                                  return SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Image.network(
                                                        "https${imgs[index]}",
                                                        fit: BoxFit.contain),
                                                  );
                                                },
                                              ),
                                      ),
                                      ..._getTextWidgets(movie, isWine),
                                    ],
                                  );
                                }
                              },
                            ),
                          )),
                    );
                  },
                );
              }).toList()),
        ),
        const SizedBox(height: 60)
      ],
    );
  }
}

List<Widget> _getTextWidgets(Map<String, dynamic> movie, bool isWine) {
  return [
    const SizedBox(height: 20),
    Text(
      isWine ? movie['en_title'] : movie['name'],
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      isWine ? movie['en_title'] : movie['address'],
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    const SizedBox(height: 20),
    Text(
      isWine ? movie['price'] + "원" : "MangoPlate Rating: " + movie['rating'],
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        isWine ? movie['description'] : movie['summary'],
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.purple], // 원하는 그라데이션 색상을 여기에 추가하세요.
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(10), // 버튼 내용의 간격을 조정하세요.
      child: Center(
        child: isWine
            ? const Text(
                "구매하러 가기",
                style: TextStyle(
                  color: Colors.white, // 텍스트 색상을 지정하세요.
                ),
              )
            : const Text(
                "상세정보 보기",
                style: TextStyle(
                  color: Colors.white, // 텍스트 색상을 지정하세요.
                ),
              ),
      ),
    ),
  ];
}
