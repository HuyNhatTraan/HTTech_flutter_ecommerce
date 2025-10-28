import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';
import 'package:hehehehe/globals.dart';

class ThongBao extends StatefulWidget {
  const ThongBao({super.key});

  @override
  State<ThongBao> createState() => _ThongBaoState();
}

class _ThongBaoState extends State<ThongBao> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Thông báo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: const [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 64,
                        color: Color(0xFF3c81c6),
                      ),
                      Text(
                        'Không có thông báo nào.',
                        style: TextStyle(
                          color: Color(0xFF3c81c6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }

                final items = snapshot.data!.docs;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 350,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item =
                              items[index].data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Color(0xFFadadad),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsetsGeometry.all(0),
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                            'https://www.gstatic.com/mobilesdk/240501_mobilesdk/firebase_28dp.png',
                                          ),
                                          width: 35,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(item['body']),
                                              Text(
                                                (() {
                                                  final t = item['time'];
                                                  if (t == null) return '';
                                                  final d = (t as Timestamp)
                                                      .toDate();
                                                  return '${d.day.toString().padLeft(2, '0')}/'
                                                      '${d.month.toString().padLeft(2, '0')}/'
                                                      '${d.year} '
                                                      '${d.hour.toString().padLeft(2, '0')}:'
                                                      '${d.minute.toString().padLeft(2, '0')}:'
                                                      '${d.second.toString().padLeft(2, '0')}';
                                                })(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 5,
                top: 20,
              ),
              child: Text(
                'Cập nhật đơn hàng',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;
                if (user == null) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.minor_crash_outlined,
                          color: Color(0xFF3c81c6),
                          size: 48,
                        ),
                        Text('Vui lòng đăng nhập để xem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3c81c6))),
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
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeInOutSine));
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
                          child: const Text('Đăng nhập ngay.', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('UserID', isEqualTo: user.uid)
                      .orderBy('NgayDatHang', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        child: Column(
                          spacing: 5,
                          children: const [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 48,
                              color: Color(0xFF3c81c6),
                            ),
                            Text(
                              'Hiện tại bạn chưa đặt đơn hàng nào',
                              style: TextStyle(
                                color: Color(0xFF3c81c6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final items = snapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item =
                                items[index].data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color(0xFFadadad),
                                        width: 1,
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsetsGeometry.all(0),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Image(
                                            image: NetworkImage(
                                              baseUri + item["AnhDonHang"],
                                            ),
                                            width: 35,
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Column(
                                              spacing: 3,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['TrangThai'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ), // style chung
                                                    children: [
                                                      TextSpan(
                                                        text: 'Đơn hàng ',
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${item['OrderID']}',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF3c81c6,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' đang được xử lý',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ), // style chung
                                                    children: [
                                                      const TextSpan(
                                                        text:
                                                            'Hình thức giao hàng: ',
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${item['HinhThucGiaoHang']}',
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF3c81c6,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  (() {
                                                    final t =
                                                        item['NgayDatHang'];
                                                    if (t == null) return '';
                                                    final d = (t as Timestamp)
                                                        .toDate();
                                                    return 'Lúc ${d.day.toString().padLeft(2, '0')}/'
                                                        '${d.month.toString().padLeft(2, '0')}/'
                                                        '${d.year} '
                                                        '${d.hour.toString().padLeft(2, '0')}:'
                                                        '${d.minute.toString().padLeft(2, '0')}:'
                                                        '${d.second.toString().padLeft(2, '0')}';
                                                  })(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text('---------- Có thể bạn sẽ thích ----------'),
            ),
            ProductCard(route: '/products'),
          ],
        ),
      ),
    );
  }
}
