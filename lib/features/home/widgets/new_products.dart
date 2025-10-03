import 'package:flutter/material.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

class SanPhamMoi extends StatefulWidget {
  const SanPhamMoi({super.key,});

  @override
  State<SanPhamMoi> createState() => _SanPhamMoiState();
}

class _SanPhamMoiState extends State<SanPhamMoi> {

  @override
  void initState() {
    super.initState();
    super.widget.key;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Text(
            "Gear mới về - cẩn thận dính ví",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        ProductCard(key: ValueKey(super.widget.key),route: '/products'),
      ],
    );
  }
}
