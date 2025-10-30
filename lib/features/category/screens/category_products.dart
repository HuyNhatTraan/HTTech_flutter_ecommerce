import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
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
  int _curentCartNum = 0;
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
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;

              if (user == null) {
                _curentCartNum = 0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const CartScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOutSine));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Color(0xFF3c81c6),
                          size: 28,
                        ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: Container(
                            width: 20,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3c81c6),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _curentCartNum.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cart')
                    .doc(user.uid)
                    .collection('SanPham')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    _curentCartNum = 0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const CartScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.easeInOutSine));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: Stack(
                          clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xFF3c81c6),
                              size: 28,
                            ),
                            Positioned(
                              right: -5,
                              bottom: -5,
                              child: Container(
                                width: 20,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3c81c6),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  _curentCartNum.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final items = snapshot.data!.docs;

                  int _tempCartNum = 0;
                  for (var item in items) {
                    _tempCartNum += int.tryParse(item['SoLuong'].toString()) ?? 0;
                  }

                  _curentCartNum = _tempCartNum;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const CartScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeInOutSine));
                            return SlideTransition(position: animation.drive(tween), child: child);
                          },
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Color(0xFF3c81c6),
                            size: 28,
                          ),
                          Positioned(
                            right: -5,
                            bottom: -5,
                            child: Container(
                              width: 20,
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF3c81c6),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                _curentCartNum.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(width: 15)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(baseUri + '/' + widget.bannerDanhMuc),
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Text(
                'Danh mục ' + widget.tenDanhMuc,
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
