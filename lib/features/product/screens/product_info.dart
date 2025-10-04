import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
import 'package:hehehehe/features/product/widgets/product_carousel.dart';
import 'package:hehehehe/features/product/widgets/product_description.dart';
import 'package:hehehehe/features/search/search_screen.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class ProductInfo extends StatefulWidget {
  final String maSanPham;
  const ProductInfo({super.key, required this.maSanPham});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  // dynamic = kiểu dữ liệu có thể là bất kỳ thứ gì (int, String, Map, List...).
  List<dynamic> _products = [];
  bool _isLoading = true; // Thêm biến để theo dõi trạng thái tải

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });
    try {
      String route = "/productInfo";
      final url = Uri.parse(baseUri + route + "/" + widget.maSanPham);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) {
          // Kiểm tra xem widget còn trong cây widget không
          setState(() {
            _products = json.decode(response.body);
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

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent, // tắt cái overlay tím
        elevation: 4,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            onFieldSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => SearchScreen(searchQuery: value),
                ),
              );
            },
            style: TextStyle(
              color: Color(0xFF3C81C6),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              isDense: true,
              prefixIcon: Icon(Icons.search, size: 24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF3c81c6),
                size: 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const CartScreen(),
                  ),
                );
                print("Đi tới giỏ hàng");
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductCarousel(maSanPham: widget.maSanPham),
            Padding(
              padding: EdgeInsets.all(0),
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
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final double giaBase = double.parse(
                          product["GiaBaseSP"].toString(),
                        );
                        final double giaSP = double.parse(
                          product["GiaSP"].toString(),
                        );

                        final int giamGia = (giaBase - giaSP).round();
                        return Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Căn chỉnh nội dung của các cột từ trên xuống
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 0,
                                        left: 15,
                                        right: 15,
                                        bottom: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFFd7d7d7),
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                spacing: 5,
                                                children: [
                                                  Text(
                                                    product["GiaSP"]
                                                        .toString()
                                                        .toVND(unit: 'đ'),
                                                    style: const TextStyle(
                                                      color: Color(0xFF3c81c6),
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  Text(
                                                    product["GiaBaseSP"]
                                                        .toString()
                                                        .toVND(unit: 'đ'),
                                                    style: const TextStyle(
                                                      color: Color(0xFF706e6e),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isFavorite = !isFavorite;
                                                  });
                                                },
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite_outlined
                                                      : Icons
                                                            .favorite_border_outlined,
                                                  color: isFavorite
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFd4f6ff),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF3c81c6),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 3,
                                              children: [
                                                Icon(
                                                  Icons.arrow_downward_outlined,
                                                  color: Color(0xFF3c81c6),
                                                  size: 18,
                                                ),
                                                Text(
                                                  'Giảm ' + giamGia.toVND(),
                                                  style: TextStyle(
                                                    color: Color(0xFF3c81c6),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            product["TenSanPham"],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            ProductDescription(maSanPham: widget.maSanPham),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 0, // chỉnh độ cao shadow
                      backgroundColor: Color(0xFFd4f6ff),
                      content: const Text(
                        'Tính năng này đang được xây dựng thử lại sau hen',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                      width: 320.0, // Width of the SnackBar.
                      padding: const EdgeInsets.all(20),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                          color: Color(0xFF706e6e),
                          width: 0.3,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Color(0xFFc6e7ff)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_shopping_cart_outlined,
                          color: Color(0xFF3c81c6),
                        ),
                        Text(
                          'Thêm vào giỏ hàng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3c81c6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 0, // chỉnh độ cao shadow
                      backgroundColor: Color(0xFFd4f6ff),
                      content: const Text(
                        'Tính năng này đang được xây dựng thử lại sau hen',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                      width: 320.0, // Width of the SnackBar.
                      padding: const EdgeInsets.all(20),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                          color: Color(0xFF706e6e),
                          width: 0.3,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Color(0xFF3c81c6)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.check_outlined, color: Colors.white),
                        Text(
                          'Mua ngay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
