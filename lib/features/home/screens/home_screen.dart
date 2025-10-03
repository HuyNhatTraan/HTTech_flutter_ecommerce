import 'package:flutter/material.dart';
import 'package:hehehehe/features/home/widgets/category_mini_home.dart';
import 'package:hehehehe/features/home/widgets/new_products.dart';
import 'package:hehehehe/features/home/widgets/banner_new_products_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _reloadProductCart = 0;
  int _reloadCategory = 1;

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Delay refresh
    setState(() {
      _reloadProductCart++; // Load lại sản phẩm
      _reloadCategory++;
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
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BannerSPMoi(),
              DanhMucSanPhamWidget(key: ValueKey(_reloadCategory),),
              SanPhamMoi(key: ValueKey(_reloadProductCart),),
            ],
          ),
        ),
      )
    );
  }
}
