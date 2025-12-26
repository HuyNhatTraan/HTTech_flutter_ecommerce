import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hehehehe/features/account/screens/account_address.dart';
import 'package:hehehehe/features/account/screens/account_support.dart';
import 'package:hehehehe/features/account/screens/account_user_info.dart';
import 'package:hehehehe/features/settings/screens/setting_versions_app.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ... [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Tài khoản', style: TextStyle(color: Colors.grey[700]),),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                AccountUserInfo(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.easeInOutSine));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Thông tin cá nhân'),
                            Icon(
                              Icons.chevron_right_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                AccountAddress(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.easeInOutSine));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Địa chỉ'),
                            Icon(
                              Icons.chevron_right_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Fluttertoast.showToast(
                            msg: "Tính năng này đang được xây dựng",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xFFd2f5fc),
                            textColor: Color(0xFF3c81c6),
                            fontSize: 16.0
                        );
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     transitionDuration: const Duration(milliseconds: 300),
                        //     pageBuilder: (context, animation, secondaryAnimation) =>
                        //         AccountAddress(),
                        //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        //       final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                        //           .chain(CurveTween(curve: Curves.easeInOutSine));
                        //       return SlideTransition(position: animation.drive(tween), child: child);
                        //     },
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hạng thành viên'),
                            Icon(
                              Icons.chevron_right_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Cài đặt', style: TextStyle(color: Colors.grey[700]),),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFd2f5fc),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cài đặt thông báo'),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFd2f5fc),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giao diện'),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFd2f5fc),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: 2,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Language / Ngôn ngữ'),
                              Text('Tiếng Việt', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Hỗ trợ', style: TextStyle(color: Colors.grey[700]),),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              AccountSupport(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeInOutSine));
                            return SlideTransition(position: animation.drive(tween), child: child);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Trung tâm hỗ trợ'),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              SettingVersionsApp(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeInOutSine));
                            return SlideTransition(position: animation.drive(tween), child: child);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Giới thiệu'),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Tính năng này đang được xây dựng",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFFd2f5fc),
                          textColor: Color(0xFF3c81c6),
                          fontSize: 16.0
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Yêu cầu xoá tài khoản'),
                          Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user != null) ... [
                    GestureDetector(
                      onTap: () async {
                        EasyLoading.show(status: 'Đợi tý nhen...', maskType: EasyLoadingMaskType.black,);
                        try {
                          await FirebaseAuth.instance.signOut();
                          final googleSignIn = GoogleSignIn.instance;
                          await googleSignIn.signOut();
                          await Future.delayed(
                            const Duration(milliseconds: 1000),
                          );
                          EasyLoading.showSuccess('Đăng xuất thành công',maskType: EasyLoadingMaskType.clear);

                          await Future.delayed(
                            const Duration(milliseconds: 700),
                          );
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        } catch (e) {
                          EasyLoading.showError(e.toString(),maskType: EasyLoadingMaskType.clear);
                          await Future.delayed(
                            const Duration(milliseconds: 1000),
                          );
                          EasyLoading.dismiss();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Đăng xuất tài khoản', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                            Icon(
                              Icons.chevron_right_outlined, color: Colors.red
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ... [
                    SizedBox()
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
