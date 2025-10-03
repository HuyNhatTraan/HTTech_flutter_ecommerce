import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent, // tắt cái overlay tím
        elevation: 4,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 4.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace_outlined),
          ),
        ),
        title: Text('Giỏ hàng', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
