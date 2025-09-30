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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerSPMoi(),
            DanhMucSanPhamWidget(),
            SanPhamMoi(),
          ],
        ),
      )
    );
  }
}
