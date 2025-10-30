import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/features/category/screens/category_brands_screen.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

class CacThuongHieuPP extends StatefulWidget {
  const CacThuongHieuPP({super.key});

  @override
  State<CacThuongHieuPP> createState() => _CacThuongHieuPPState();
}

class _CacThuongHieuPPState extends State<CacThuongHieuPP> {
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
      String route = "/brands";
      final url = Uri.parse(baseUri + route);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top:10, bottom: 0),
          child: Text(
            "Phân phối chính hãng",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: _isLoading // Sử dụng _isLoading thay vì _products.isEmpty cho CircularProgressIndicator
              ? const Center(child: CircularProgressIndicator())
              : _products.isEmpty // Sau khi tải xong, nếu không có sản phẩm thì hiển thị thông báo
              ? Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Không có thông báo nào.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ): GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // số cột
                mainAxisExtent: 150
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DanhMucSPBrand(maThuongHieu: product["MaThuongHieu"], bannerThuongHieu: product["BannerThuongHieu"], tenThuongHieu: product["TenThuongHieu"]),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOutSine));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                    ),
                  );
                  print('Đã ấn ' + product["TenThuongHieu"]);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh nội dung của các cột từ trên xuống
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey, width: 1),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider('$baseUri/${product['ImgThuongHieu']}'),
                                  //fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).fadeInUp(from: 50, duration: Duration(milliseconds: 400));
            },
          ),
        ),
      ],
    );
  }
}
