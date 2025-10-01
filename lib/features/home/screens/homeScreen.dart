import 'package:flutter/material.dart';
import 'package:hehehehe/features/home/widgets/danhMucSanPham.dart';
import 'package:hehehehe/features/home/widgets/sanPhamMoi.dart';
import 'package:hehehehe/features/home/widgets/bannerSPMoi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _reloadCount = 0;

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Delay refresh
    setState(() {
      _reloadCount++; // Load lại sản phẩm
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
          child: Column(
            children: [
              BannerSPMoi(),
              DanhMucSanPhamWidget(),
              SanPhamMoi(key: ValueKey(_reloadCount),),
            ],
          ),
        ),
      )
    );
  }
}
