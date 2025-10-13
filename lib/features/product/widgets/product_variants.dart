import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductVarients extends StatefulWidget {
  final maSanPham;
  const ProductVarients({super.key, required this.maSanPham});

  @override
  State<ProductVarients> createState() => _ProductVarientsState();
}

class _ProductVarientsState extends State<ProductVarients> {
  List _productVarients = [];

  Future fetchProductVariants() async {

  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
