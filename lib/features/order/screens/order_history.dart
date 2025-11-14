import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
import 'package:hehehehe/globals.dart' as globals;

class AccountOrderHistory extends StatefulWidget {
  const AccountOrderHistory({super.key});

  @override
  State<AccountOrderHistory> createState() => _AccountOrderHistoryState();
}

class _AccountOrderHistoryState extends State<AccountOrderHistory> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();

  int _curentCartNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_backspace_outlined),
        ),
        title: const Text(
          'Lịch sử đặt hàng',
          style: TextStyle(fontWeight: FontWeight.w900),
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
                      clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon giỏ hàng ớ
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Color(0xFF3c81c6),
                          size: 28,
                        ),
                        Positioned(
                          right: -15,
                          bottom: -10,
                          child: Container(
                            width: 35,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3c81c6),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _curentCartNum > 99 ? '99+' : _curentCartNum.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
                          clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon giỏ hàng ớ
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xFF3c81c6),
                              size: 28,
                            ),
                            Positioned(
                              right: -15,
                              bottom: -10,
                              child: Container(
                                width: 35,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3c81c6),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _curentCartNum > 99 ? '99+' : _curentCartNum.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _curentCartNum > 99 ? 10 : 12,
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
                        clipBehavior: Clip.none, // cho phép chữ tràn ra ngoài icon giỏ hàng ớ
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Color(0xFF3c81c6),
                            size: 28,
                          ),
                          Positioned(
                            right: -15,
                            bottom: -10,
                            child: Container(
                              width: 35,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF3c81c6),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _curentCartNum > 99 ? '99+' : _curentCartNum.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _curentCartNum > 99 ? 10 : 12,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('UserID', isEqualTo: user!.uid)
            .orderBy('NgayDatHang', descending: true)
            .snapshots(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderSnapshot.hasError) {
            return Center(child: Text('Lỗi: ${orderSnapshot.error}'));
          }

          if (!orderSnapshot.hasData || orderSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.production_quantity_limits_outlined, size: 64, color: Color(0xFF3c81c6)),
                  const SizedBox(height: 15),
                  const Text(
                    'Bạn chưa có đơn hàng nào cả',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3c81c6),
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD2F5FC),
                      foregroundColor: const Color(0xFF3C81C6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                        const BorderSide(color: Color(0xFF3C81C6), width: 1),
                      ),
                    ),
                    child: const Text('Tiếp tục mua hàng',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          final orders = orderSnapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order.id;
              final orderData = order.data() as Map<String, dynamic>;

              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xFFa5a5a5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header đơn hàng
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mã đơn: $orderId',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            orderData['TrangThai'] ?? "Đang xử lý",
                            style: const TextStyle(
                                color: Color(0xFF3C81C6),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        'Ngày đặt: ${(orderData['NgayDatHang'] as Timestamp).toDate()}.',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),

                    // === Danh sách sản phẩm ===
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .collection('SanPham')
                          .snapshots(),
                      builder: (context, productSnapshot) {
                        if (!productSnapshot.hasData) {
                          return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ));
                        }

                        final products = productSnapshot.data!.docs;
                        num tongTien = 0;

                        for (var p in products) {
                          final sp = p.data() as Map<String, dynamic>;
                          final gia = num.tryParse(sp["GiaSP"].toString()) ?? 0;
                          final sl = sp["SoLuong"] ?? 1;
                          tongTien += gia * sl;
                        }

                        return Column(
                          children: [
                            ...products.map((product) {
                              final data =
                              product.data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey[400]!, width: .5),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                '${globals.baseUri}/${data["HinhAnhVariant"]}'
                                            ),
                                        )
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data["TenSP"] ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Phân loại: ${data["ThuocTinhSP"] ?? ""}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data["GiaSP"].toString().toVND(),
                                            style: const TextStyle(
                                                color: Color(0xFF3C81C6),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            'Số lượng: ${data["SoLuong"]}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  const Text("Tổng tiền:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(tongTien.toString().toVND(),
                                    style: const TextStyle(
                                        color: Color(0xFF3C81C6),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}