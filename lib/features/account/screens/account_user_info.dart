import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hehehehe/features/account/screens/account_edit_user_info.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/globals.dart' as globals;

class AccountUserInfo extends StatefulWidget {
  const AccountUserInfo({super.key});

  @override
  State<AccountUserInfo> createState() => _AccountUserInfoState();
}

class _AccountUserInfoState extends State<AccountUserInfo> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          "Thông tin cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không tìm thấy thông tin người dùng"));
            }

            final userData = snapshot.data!;

            final currentUser = FirebaseAuth.instance.currentUser;
            final String tempAvatarUrl = userData['AvatarUrl'];
            final String avatarUrl = tempAvatarUrl.startsWith('http')
                ? tempAvatarUrl
                : '${globals.baseUri}/$tempAvatarUrl';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Banner User
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            '${globals.baseUri}/assets/account/images/bannerAccount.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Hình ảnh User
                    Positioned(
                      right: 1,
                      left: 1,
                      bottom: -30,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          print('Đã ấn hình ảnh Avatar');
                        },
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color(0xFF3c81c6),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: (){
                                print('object');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)
                                      ),
                                    ),
                                    child: Text(
                                      'Sửa',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsetsGeometry.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    color: Color(0xFF3c81c6),
                                  ),
                                  Text(
                                    "${userData['name'] ?? currentUser?.displayName ?? 'Chưa có'}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text('Email', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF3c81c6),
                                  ),
                                  Text(
                                    "${userData['email'] ?? currentUser?.email ?? 'Chưa có'}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text('Số điện thoại', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: Color(0xFF3c81c6),
                                  ),
                                  Text(
                                    "${userData['sdt'] ?? 'Chưa thêm số điện thoại'}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text('Ngày đăng ký', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.date_range_outlined,
                                    color: Color(0xFF3c81c6),
                                  ),
                                  Text(
                                    (() {
                                      final createdAt = userData['createdAt'];
                                      DateTime? d;

                                      if (createdAt is Timestamp) {
                                        d = createdAt.toDate();
                                      } else if (currentUser?.metadata.creationTime != null) {
                                        d = currentUser!.metadata.creationTime!;
                                      }

                                      if (d == null) return 'Không rõ';

                                      return '${d.day.toString().padLeft(2, '0')}/'
                                          '${d.month.toString().padLeft(2, '0')}/'
                                          '${d.year} '
                                          '${d.hour.toString().padLeft(2, '0')}:'
                                          '${d.minute.toString().padLeft(2, '0')}:'
                                          '${d.second.toString().padLeft(2, '0')}';
                                    })(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),

                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text('Hạng thành viên', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.workspace_premium_outlined,
                                    color: Color(0xFF3c81c6),
                                  ),
                                  Text(
                                    "${userData['HangThanhVien'] ?? 'Nhựa'}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: ElevatedButton(
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
                                AccountEditUserInfo(),
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
                          child: Text('Chỉnh sửa thông tin cá nhân',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF3c81c6),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
