import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCarousel extends StatefulWidget {
  final String maSanPham;
  const ProductCarousel({super.key, required this.maSanPham});

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    fetchProductsImages();
  }

  Future<void> fetchProductsImages() async {
    try {
      String route = "/productCarousel";
      final url = Uri.parse("$baseUri$route/${widget.maSanPham}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) {
          // Kiểm tra xem widget còn trong cây widget không
          setState(() {
            list = json.decode(response.body);
          });
        }
      } else {
        throw Exception(
          "Failed to load products, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print(e);
    }
  }

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF706e6e)),
                  bottom: BorderSide(color: Color(0xFF706e6e)),
                )
            ),
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                animateToClosest: true,
              ),
              items: list.map((item) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage("$baseUri/${item["ImgUrl"]}"),fit: BoxFit.fitHeight
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: list.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage('$baseUri/${entry.value["ImgUrl"]}'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Color(0xFF706e6e),
                          width: 1
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ]
      )
    );
  }
}
