import 'package:flutter/material.dart';

class CheckoutSuccess extends StatefulWidget {
  const CheckoutSuccess({super.key});

  @override
  State<CheckoutSuccess> createState() => _CheckoutSuccessState();
}

class _CheckoutSuccessState extends State<CheckoutSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Icon(
            Icons.keyboard_backspace_outlined,
            size: 32,
          ),
        ),
        title: const Text('Thanh toán'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.done_outlined,
                color: Color(0xFF3c81c6),
                size: 64,
              ),
              Text('Đặt hàng thành công', style: TextStyle(fontSize: 24, color: Color(0xFF3c81c6), fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}