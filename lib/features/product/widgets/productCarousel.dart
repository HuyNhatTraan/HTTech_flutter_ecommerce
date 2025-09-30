import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCarousel extends StatefulWidget {
  final String MaSanPham;
  const ProductCarousel({super.key, required this.MaSanPham});

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  List<dynamic> list = [];

  bool _isLoading = true; // Thêm biến để theo dõi trạng thái tải

  @override
  void initState() {
    super.initState();
    fetchProductsImages();
  }

  Future<void> fetchProductsImages() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });
    try {
      String route = "/productCarousel";
      final url = Uri.parse(baseUri + route + "/" + widget.MaSanPham);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) {
          // Kiểm tra xem widget còn trong cây widget không
          setState(() {
            list = json.decode(response.body);

            _isLoading = false; // Tải xong
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false; // Tải lỗi
          });
        }
        throw Exception(
          "Failed to load products, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Tải lỗi
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF706e6e)),
          bottom: BorderSide(color: Color(0xFF706e6e)),
        )
      ),
      child: CarouselSlider(
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
                  image: NetworkImage(baseUri + '/' + item['ImgUrl']!),fit: BoxFit.fitHeight
                ),
              ),
            );
          }).toList(),
      ),
    );
  }
}
