import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/widgets/cart_button_widget.dart';
import 'package:hehehehe/globals.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

class DanhMucSPBrand extends StatefulWidget {
  const DanhMucSPBrand({
    super.key,
    required this.maThuongHieu,
    required this.bannerThuongHieu,
    required this.tenThuongHieu,
  });

  final String maThuongHieu;
  final String bannerThuongHieu;
  final String tenThuongHieu;

  @override
  State<DanhMucSPBrand> createState() => _DanhMucSPBrandState();
}

class _DanhMucSPBrandState extends State<DanhMucSPBrand> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int curentCartNum = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tenThuongHieu,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        surfaceTintColor: Colors.white,
        actions: [const CartButtonWidget()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              image: NetworkImage('$baseUri/${widget.bannerThuongHieu}'),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Thương hiệu ${widget.tenThuongHieu}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ProductCard(route: '/brands', maThuongHieu: widget.maThuongHieu),
          ],
        ),
      ),
    );
  }
}
