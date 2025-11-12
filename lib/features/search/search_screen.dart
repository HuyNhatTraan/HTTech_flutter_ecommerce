import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _currentQuery; // giữ từ khóa hiện tại

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.searchQuery; // khởi tạo từ tham số truyền vào
  }

  @override
  Widget build(BuildContext context) {
    int _curentCartNum = 0;
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                _currentQuery = value; // cập nhật query => rebuild ProductCard
              });
            },
            initialValue: widget.searchQuery,
            style: const TextStyle(
              color: Color(0xFF3C81C6),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              isDense: true,
              prefixIcon: const Icon(Icons.search, size: 24, color: Color(0xFF3c81c6),),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color(0xFF3c81c6)
                  )
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF3c81c6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF3c81c6)),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF9e9e9e)), bottom: BorderSide(color: Color(0xFF9e9e9e))),
                color: Colors.white,
              ),
              //width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFc6e7ff),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text('Liên quan', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey[800],
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFc6e7ff),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text('Mới nhất', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey[800],
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFc6e7ff),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.north_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                          Text('Giá', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Row(
                    children: [
                      const Text(
                        'Kết quả cho: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "' $_currentQuery ' ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3c81c6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ProductCard(
              key: ValueKey(_currentQuery),
              route: '/products',
              tenSanPham: _currentQuery,
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
