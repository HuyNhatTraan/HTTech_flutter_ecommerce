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

  const ProductCard({
    super.key,
    required this.route,
    this.maDanhMuc,
    this.maThuongHieu,
    this.tenSanPham,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // dynamic = kiểu dữ liệu có thể là bất kỳ thứ gì (int, String, Map, List...).
  List<dynamic> _products = [];
  bool _isLoading = false; // Thêm biến để theo dõi trạng thái tải

  @override
  void initState() {
    super.initState();
    fetchProducts(
      widget.route,
      widget.maDanhMuc,
      widget.maThuongHieu,
      widget.tenSanPham,
    );
  }

  Future<void> fetchProducts(
    String route,
    String? maDanhMuc,
    String? maThuongHieu,
    String? tenSanPham,
  ) async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });
    try {
      Uri url;
      if (maDanhMuc != null) {
        final urlCustom = Uri.parse(globals.baseUri + route + '/' + maDanhMuc);
        url = urlCustom;
      } else if (maThuongHieu != null) {
        final urlCustom = Uri.parse(
          globals.baseUri + route + '/' + maThuongHieu,
        );
        url = urlCustom;
      } else if (tenSanPham != null) {
        final urlCustom = Uri.parse(globals.baseUri + route + '/' + tenSanPham);
        url = urlCustom;
      } else {
        final urlCustom = Uri.parse(globals.baseUri + route);
        url = urlCustom;
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
          _isLoading = false; // Tải xong
        });
      } else {
        setState(() {
          _isLoading = false; // Tải lỗi
        });
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _products
                    .isEmpty // Nếu không rỗng thì hiển thị sản phẩm mới
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Không tìm thấy sản phẩm nào.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // số cột
                    mainAxisExtent: 310,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: true, // Giữ màn cũ hiển thị
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return ProductInfo(
                                            maSanPham: product["MaSanPham"],
                                          );
                                        },
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          final tween =
                                              Tween(
                                                begin: const Offset(1.0, 0.0),
                                                end: Offset.zero,
                                              ).chain(
                                                CurveTween(
                                                  curve: Curves.easeInOutSine,
                                                ),
                                              );

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                  ),
                                );
                                print('Đã ấn ' + product["MaSanPham"]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ảnh sản phẩm
                                    Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            globals.baseUri +
                                                '/' +
                                                product["HinhAnhDaiDienSP"],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product["TenSanPham"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          // Giá
                                          Row(
                                            children: [
                                              Text(
                                                product["GiaSP"]
                                                    .toString()
                                                    .toVND(unit: 'đ'),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // Rating + đã bán
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text("4.9"),
                                              SizedBox(width: 8),
                                              Text(
                                                "Đã bán 500 cái",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).fadeInUp(
                      from: 100,
                      duration: Duration(milliseconds: 400),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
