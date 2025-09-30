import 'package:flutter/material.dart';
import 'package:hehehehe/features/category/widgets/danhMucSanPham.dart';
import 'package:hehehehe/features/category/widgets/cacThuongHieuPP.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DanhMucSanPhamFullWidget(),
            CacThuongHieuPP(),
          ],
        ),
      )
    );
  }
}
