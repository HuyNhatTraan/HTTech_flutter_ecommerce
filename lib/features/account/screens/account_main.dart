import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart' as globals;
import 'package:hehehehe/features/account/widgets/tools.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hehehehe/features/account/widgets/account_info_banner.dart';


class AccountMain extends StatefulWidget {
  const AccountMain({super.key});

  @override
  State<AccountMain> createState() => _AccountMainState();
}

class _AccountMainState extends State<AccountMain> {

  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Người dùng đã đăng nhập
      print('Người dùng đã đăng nhập!');
      print('User ID: ${user.uid}');
      print('Email: ${user.email}');
    } else {
      // Người dùng chưa đăng nhập
      print('Không có người dùng nào đang đăng nhập.');
    }
  }

  int _reloadAccount = 0;

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Delay refresh
    setState(() {
      _reloadAccount++; // Load lại sản phẩm
      print("Dữ liệu đã reload hehehe");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      body: RefreshIndicator(
        onRefresh: _reloadData,
        color: Color(0xFF3c81c6),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            key: ValueKey(_reloadAccount),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner user
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            globals.baseUri + '/'+ 'assets/account/images/bannerAccount.png',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.1),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StreamBuilder<User?>(
                                  stream: FirebaseAuth.instance.authStateChanges(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData || snapshot.data == null) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Tên user
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Bạn chưa đăng nhập',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStatePropertyAll(Color(0xFFd2f5fc)),
                                                side: WidgetStatePropertyAll(
                                                  BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  ),
                                                ),
                                                elevation: WidgetStatePropertyAll(0),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    opaque: true, // Giữ màn cũ hiển thị
                                                    transitionDuration: const Duration(milliseconds: 300),
                                                    pageBuilder: (context, animation, secondaryAnimation) {
                                                      return LoginScreen();
                                                    },
                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                      final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                                          .chain(CurveTween(curve: Curves.easeInOutSine));

                                                      return SlideTransition(
                                                        position: animation.drive(tween),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text('Đăng nhập ngay', style: TextStyle(color: Color(0xFF3c81c6), fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    final user = snapshot.data!;
                                    return AccountInfoBanner(user: user);
                                  }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Công cụ hữu ích đã hen
              Tools(),
            ],
          ),
        ),
      )
    );
  }
}
