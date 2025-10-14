import 'package:flutter/material.dart';

class AccountAddress extends StatefulWidget {
  const AccountAddress({super.key});

  @override
  State<AccountAddress> createState() => _AccountAddressState();
}

class _AccountAddressState extends State<AccountAddress> {
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
        title: Text('Danh sách địa chỉ', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
            Text('Danh sách đơn hàng'),
          ],
        ),

      ),
    );
  }
}
