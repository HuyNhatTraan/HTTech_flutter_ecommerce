import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';

class CartButtonWidget extends StatefulWidget {
  const CartButtonWidget({super.key});

  @override
  State<CartButtonWidget> createState() => _CartButtonWidgetState();
}

class _CartButtonWidgetState extends State<CartButtonWidget> {
  int _currentCartNum = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            if (user == null) {
              _currentCartNum = 0;
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
                  padding: const EdgeInsets.all(0),
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
                            _currentCartNum > 99 ? '99+' : _currentCartNum.toString(),
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
                  _currentCartNum = 0;
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
                      padding: const EdgeInsets.all(0),
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
                                _currentCartNum > 99 ? '99+' : _currentCartNum.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _currentCartNum > 99 ? 10 : 12,
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

                int tempCartNum = 0;
                for (var item in items) {
                  tempCartNum += int.tryParse(item['SoLuong'].toString()) ?? 0;
                }

                _currentCartNum = tempCartNum;

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
                              _currentCartNum > 99 ? '99+' : _currentCartNum.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _currentCartNum > 99 ? 10 : 12,
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
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
