import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:hehehehe/features/product/screens/product_info.dart';
import 'package:animate_do/animate_do.dart';

class ProductCard extends StatefulWidget {
  final String route;
  final String? maDanhMuc;
  final String? maThuongHieu;
  final String? tenSanPham;
  final String? sort;

  const ProductCard({
    super.key,
    required this.route,
    this.maDanhMuc,
    this.maThuongHieu,
    this.tenSanPham,
    this.sort,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<dynamic> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts(widget.route, widget.maDanhMuc, widget.maThuongHieu, widget.tenSanPham, widget.sort);
  }

  Future<void> fetchProducts(String route, String? maDanhMuc, String? maThuongHieu, String? tenSanPham, String? sort) async {
    setState(() => _isLoading = true);

    Uri url;
    if (maDanhMuc != null) {
      final urlCustom = Uri.parse('${globals.baseUri}$route/$maDanhMuc');
      url = urlCustom;
    } else if (maThuongHieu != null) {
      final urlCustom = Uri.parse('${globals.baseUri}$route/$maThuongHieu');
      url = urlCustom;
    } else if (tenSanPham != null) {
      final urlCustom = Uri.parse('${globals.baseUri}$route?search=$tenSanPham&sort=$sort');
      url = urlCustom;
    } else {
      final urlCustom = Uri.parse(globals.baseUri + route);
      url = urlCustom;
    }

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải sản phẩm: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Không tìm thấy sản phẩm nào.",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 300,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductInfo(maSanPham: product["MaSanPham"]),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOutSine));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Ảnh
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider("${globals.baseUri}/${product["HinhAnhDaiDienSP"]}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Thông tin
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product["TenSanPham"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(product["GiaSP"].toString().toVND(unit: 'đ'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text("4.9"),
                      SizedBox(width: 8),
                      Text("Đã bán 500 cái", style: TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ).fadeInUp(from: 100, duration: const Duration(milliseconds: 400)),
    );
  }
}