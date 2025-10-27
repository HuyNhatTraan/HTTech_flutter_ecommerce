import 'package:flutter/material.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hehehehe/globals.dart' as globals;

class AccountInfoBanner extends StatefulWidget {
  final dynamic user;
  const AccountInfoBanner({super.key, this.user});

  @override
  State<AccountInfoBanner> createState() => _AccountInfoBannerState();
}

class _AccountInfoBannerState extends State<AccountInfoBanner> {
  final User? user = FirebaseAuth.instance.currentUser;
  AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: authService.getUser(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container( padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Không tìm thấy thông tin người dùng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),));
        }

        final userData = snapshot.data!;

        return Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: userData['AvatarUrl'] != null && userData['AvatarUrl'].toString().startsWith('http')
                      ? NetworkImage(userData['AvatarUrl'])
                      : NetworkImage('${globals.baseUri}/${userData['AvatarUrl']}'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Color(0xFF3c81c6),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Xin chào ${userData['name']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Email: ${userData['email']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Hạng thành viên: ${userData['HangThanhVien']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
