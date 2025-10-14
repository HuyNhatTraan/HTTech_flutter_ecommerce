import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';

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
      appBar: AppBar(title: Text("Thông tin cá nhân", style: TextStyle(fontWeight: FontWeight.bold),)),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: authService.getUser(user!.uid),
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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Họ tên: ${userData['name'] ?? 'Chưa có'}",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Email: ${userData['email'] ?? 'Chưa có'}"),
                SizedBox(height: 10),
                Text("Số điện thoại: ${userData['SoDienThoai'] ?? 'Chưa có'}"),
                SizedBox(height: 10),
                Text("Ngày đăng ký: ${(userData['createdAt'] as Timestamp).toDate().toString()}"),
                SizedBox(height: 10),
                Text("Hạng thành viên: ${userData['HangThanhVien'] ?? 'Chưa có'}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
