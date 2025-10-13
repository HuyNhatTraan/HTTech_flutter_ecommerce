import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // nhớ import
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/globals.dart' as globals;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int tongTienHeHe = 0; // biến tổng tiền toàn cục cho State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_backspace_outlined),
        ),
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: user == null
          ? _buildLoginPrompt(context)
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('SanPham')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Giỏ hàng trống 😢'));
          }

          // 👉 tính tổng tiền
          int tong = 0;
          final items = snapshot.data!.docs;
          for (var doc in items) {
            final gia = int.tryParse(doc['GiaSP'].toString()) ?? 0;
            final soLuong = int.tryParse(doc['SoLuong'].toString()) ?? 0;

            tong += gia * soLuong;
          }

          // cập nhật vào biến state cho bottomNav
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (tongTienHeHe != tong) {
              setState(() => tongTienHeHe = tong);
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              final GiaSP = item["GiaSP"].toString();
              final SoLuong = item["SoLuong"];
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(
                          '${globals.baseUri}/${item["HinhAnhVariant"]}',
                          height: 60,
                          fit: BoxFit.fitHeight,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  item["TenSP"] ?? "",
                                  maxLines: 4,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  GiaSP.toVND(),
                                  style: const TextStyle(
                                      color: Color(0xFF3c81c6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text('Số lượng: $SoLuong'),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.remove_outlined,
                                    size: 16),
                              ),
                              Text(SoLuong.toString()),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.add_outlined,
                                    size: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng cộng:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  tongTienHeHe.toString().toVND(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3c81c6)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2F5FC),
                    foregroundColor: const Color(0xFF3C81C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFF3C81C6),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.production_quantity_limits_outlined,
              size: 64, color: Color(0xFF3c81c6)),
          const SizedBox(height: 15),
          const Text(
            'Vui lòng đăng nhập để xem giỏ hàng.',
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF3c81c6),
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final tween = Tween(
                        begin: const Offset(1, 0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOutSine));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFD2F5FC),
              foregroundColor: const Color(0xFF3C81C6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF3C81C6), width: 1),
              ),
            ),
            child: const Text('Đăng nhập ngay.'),
          ),
        ],
      ),
    );
  }
}
