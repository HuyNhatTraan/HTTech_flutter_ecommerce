import 'package:flutter/material.dart';
import 'package:hehehehe/features/order/screens/order_history.dart';

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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    surfaceTintColor: WidgetStatePropertyAll(Color(0xFF3c81c6)),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AccountOrderHistory(),
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
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    child: Text(
                      'Xem đơn hàng của bạn ngay!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3c81c6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}