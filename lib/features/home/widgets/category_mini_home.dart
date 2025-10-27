import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:hehehehe/features/category/screens/category_products.dart';
import 'dart:convert';

class DanhMucSanPhamWidget extends StatefulWidget {
  const DanhMucSanPhamWidget({super.key});

  @override
  State<DanhMucSanPhamWidget> createState() => _DanhMucSanPhamWidgetState();
}

class _DanhMucSanPhamWidgetState extends State<DanhMucSanPhamWidget> {
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
      String route = "/categoryHomePage";
      final url = Uri.parse(globals.baseUri + route);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) { // Kiểm tra xem widget còn trong cây widget không
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
        throw Exception("Failed to load products, status code: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Tải lỗi
        });
      }
    }
  }

  //Widget currentBody = const DanhMucSanPhamWidget();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần tiêu đề riêng dòng
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "Danh mục sản phẩm",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DanhMucSanPhamProducts(maDanhMuc: 'DM01', tenDanhMuc: 'Chuột', bannerDanhMuc: 'assets/category/images/chuot-gaming-banner_730e8164-fb23-4b96-9cb0-98e85e9c1a44.webp',),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOutSine));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF9d9d9d)),
                      color: Color(0xFFCCC6C6),
                      image: DecorationImage(
                        image: NetworkImage(globals.baseUri + '/assets/category/images/icon-chuot-gaming-2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DanhMucSanPhamProducts(maDanhMuc: 'DM02', tenDanhMuc: 'Bàn phím', bannerDanhMuc: 'assets/category/images/Ban-phim-co.webp',),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOutSine));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF9d9d9d)),
                      color: Color(0xFFCCC6C6),
                      image: DecorationImage(
                        image: NetworkImage(globals.baseUri + '/assets/category/images/icon-ban-phim-gaming-2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DanhMucSanPhamProducts(maDanhMuc: 'DM04', tenDanhMuc: 'Pad chuột', bannerDanhMuc: 'assets/category/images/lot-chuot-101817.webp',),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOutSine));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF9d9d9d)),
                      color: Color(0xFFCCC6C6),
                      image: DecorationImage(
                        image: NetworkImage(globals.baseUri + '/assets/category/images/icon-lot-chuot-2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    globals.currentPageIndex.value = 1;
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCCC6C6),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Xem tất cả",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF696666),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
