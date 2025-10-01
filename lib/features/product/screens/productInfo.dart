import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/screens/cartScreen.dart';
import 'package:hehehehe/features/product/widgets/productCarousel.dart';
import 'package:hehehehe/features/product/widgets/productDescription.dart';
import 'package:hehehehe/features/search/search_screen.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class ProductInfo extends StatefulWidget {
  final String MaSanPham;
  const ProductInfo({super.key, required this.MaSanPham});

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
      final url = Uri.parse(baseUri + route + "/" + widget.MaSanPham);
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
            ProductCarousel(MaSanPham: widget.MaSanPham),
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
                        return Container(
                          padding: EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Căn chỉnh nội dung của các cột từ trên xuống
                            children: [
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  product["GiaSP"]
                                                      .toString()
                                                      .toVND(unit: 'đ'),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xFF3c81c6),
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons
                                                              .favorite_outlined
                                                        : Icons
                                                              .favorite_border_outlined,
                                                    color: isFavorite
                                                        ? Colors.red
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            ProductDescription(MaSanPham: widget.MaSanPham),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(color: Color(0xFFc6e7ff)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart_outlined, color: Color(0xFF3c81c6)),
                      Text('Thêm vào giỏ hàng', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF3c81c6), fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
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
