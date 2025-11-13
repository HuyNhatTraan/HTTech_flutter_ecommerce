import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDescription extends StatefulWidget {
  final String maSanPham;
  const ProductDescription({super.key, required this.maSanPham});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
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
      String route = "/productDescription";
      final url = Uri.parse('$baseUri$route/${widget.maSanPham}');
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
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFd7d7d7)),
          bottom: BorderSide(color: Color(0xFFd7d7d7)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin sản phẩm',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(widget.maSanPham),
          Padding(
            padding: EdgeInsetsGeometry.all(0),
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
            ): ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh nội dung của các cột từ trên xuống
                      children: [
                        Text('${product["TenThongSo"]}: ${product["NoiDungThongSo"]}', maxLines: 2,),
                      ],
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
