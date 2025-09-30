import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThongBao extends StatefulWidget {
  const ThongBao({super.key});

  @override
  State<ThongBao> createState() => _ThongBaoState();
}

class _ThongBaoState extends State<ThongBao> {
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
      String route = "/";
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
    return Scaffold(
        backgroundColor: Color(0xFFf6f6f6),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 20,
                ),
                child: Text(
                  "Thông báo",
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
                    return Container(
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
                                    image: DecorationImage(
                                      image: AssetImage(
                                        product['ImgThuongHieu'],
                                      ),
                                      //fit: BoxFit.cover,
                                    ),
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
            ],
          ),
        )
    );
  }
}