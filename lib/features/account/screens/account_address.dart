import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hehehehe/features/account/screens/account_new_address.dart';

class AccountAddress extends StatefulWidget {
  const AccountAddress({super.key});

  @override
  State<AccountAddress> createState() => _AccountAddressState();
}

class _AccountAddressState extends State<AccountAddress> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
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
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("address")
                    .doc(user?.uid)
                    .collection("UserAddress")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 3,
                          children: [
                            Icon(
                              Icons.add_home_outlined,
                              size: 64,
                              color: Color(0xFF3c81c6),
                            ),
                            Text(
                              'Bạn chưa có địa chỉ nào cả.',
                              style: TextStyle(
                                color: Color(0xFF3c81c6),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final items = snapshot.data!.docs;

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
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
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 3,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['HoVaTen'],
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                              child: VerticalDivider(
                                                color: Colors.grey[600],
                                                thickness: 1,
                                              ),
                                            ),
                                            Text(
                                              item['SDT'],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(item['Address'], style: TextStyle(color: Color(0xFF1d1e1f)),),
                                        Text('Note: ${item['Notes']}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    },
                  );
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  surfaceTintColor: WidgetStatePropertyAll(
                    Color(0xFF3c81c6),
                  ),
                  overlayColor: WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey)
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
                          AccountNewAddress(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOutSine));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    child: Text('Thêm địa chỉ ngay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3c81c6),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
