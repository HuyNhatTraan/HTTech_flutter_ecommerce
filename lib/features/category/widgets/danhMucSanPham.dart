import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hehehehe/features/category/screens/danhMucSanPhamProducts.dart';
import 'package:animate_do/animate_do.dart';

class DanhMucSanPhamFullWidget extends StatefulWidget {
  const DanhMucSanPhamFullWidget({super.key});
  @override
  State<DanhMucSanPhamFullWidget> createState() =>
      _DanhMucSanPhamFullWidgetState();
}

class _DanhMucSanPhamFullWidgetState extends State<DanhMucSanPhamFullWidget> {
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
      String route = "/category";
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
          padding: const EdgeInsets.only(left: 10, right: 10, top:20, bottom: 0),
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
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DanhMucSanPhamProducts(MaDanhMuc: product["MaDanhMuc"], TenDanhMuc: product["TenDanhMuc"], BannerDanhMuc: product["BannerDanhMuc"])));
                  print('Đã ấn ' + product["TenDanhMuc"]);
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
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey, width: 1),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    baseUri + '/' + product["HinhAnhDanhMuc"],
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black26,
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  product["TenDanhMuc"],
                                  textAlign:
                                  TextAlign.center, // phòng khi text dài nhiều dòng
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
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
