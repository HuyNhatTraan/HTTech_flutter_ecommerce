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

        // Phần Grid + "Xem tất cả" chung 1 hàng
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _products.isEmpty
                        ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Không tìm thấy sản phẩm nào.",
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                        : GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // số cột
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DanhMucSanPhamProducts(maDanhMuc: product["MaDanhMuc"], tenDanhMuc: product["TenDanhMuc"], bannerDanhMuc: product["BannerDanhMuc"])));
                            print('Đã ấn vào danh mục ' + product["MaDanhMuc"]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey, width: 1),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    globals.baseUri + '/' + product["SmallIconDanhMuc"],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Nút "Xem tất cả"
                  GestureDetector(
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
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}
