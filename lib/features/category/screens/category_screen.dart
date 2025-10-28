import 'package:flutter/material.dart';
import 'package:hehehehe/features/category/widgets/category_products_widget.dart';
import 'package:hehehehe/features/category/widgets/category_brand_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int reloadCategoryCount = 1;
  int reloadBrandCount = 0;

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Delay refresh
    setState(() {
      reloadCategoryCount++; // Load lại sản phẩm
      reloadBrandCount++;
      print("Dữ liệu đã reload hehehe");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      body: RefreshIndicator(
        color: Color(0xFF3c81c6),
        onRefresh: _reloadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              DanhMucSanPhamFullWidget(key: ValueKey(reloadCategoryCount)),
              CacThuongHieuPP(key: ValueKey(reloadBrandCount)),
            ],
          ),
        ),
      ),
    );
  }
}
