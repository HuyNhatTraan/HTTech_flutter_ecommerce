import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/widgets/cart_button_widget.dart';
import 'package:hehehehe/globals.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

class DanhMucSanPhamProducts extends StatefulWidget {
  final String maDanhMuc;
  final String tenDanhMuc;
  final String bannerDanhMuc;

  const DanhMucSanPhamProducts({
    super.key,
    required this.maDanhMuc,
    required this.tenDanhMuc,
    required this.bannerDanhMuc,
  });

  @override
  State<DanhMucSanPhamProducts> createState() => _DanhMucSanPhamProductsState();
}

class _DanhMucSanPhamProductsState extends State<DanhMucSanPhamProducts> {
  final int _curentCartNum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent, // tắt cái overlay tím
        elevation: 4,
        title: Text(
          widget.tenDanhMuc,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [const CartButtonWidget()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage('$baseUri/${widget.bannerDanhMuc}'),
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                'Danh mục ${widget.tenDanhMuc}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ProductCard(route: '/categoryProduct', maDanhMuc: widget.maDanhMuc),
          ],
        ),
      ),
    );
  }
}
