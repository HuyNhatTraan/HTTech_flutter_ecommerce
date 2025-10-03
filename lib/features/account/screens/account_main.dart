import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart' as globals;
import 'package:hehehehe/features/account/widgets/tools.dart';
import 'package:hehehehe/features/auth/screens/loginScreen.dart';
class AccountMain extends StatefulWidget {
  const AccountMain({super.key});

  @override
  State<AccountMain> createState() => _AccountMainState();
}

class _AccountMainState extends State<AccountMain> {
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
                            Colors.black.withOpacity(0.2),
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
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        globals.baseUri + '/' + 'assets/account/images/Resonator_Lupa.png',
                                      ),
                                      // fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tên user
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'HuyNhatTran',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Email: Huy1104*****@gmail.com',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Hạng thành viên: Diamond hẹ hẹ hẹ',
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Làm chỗ test UI đăng nhập và đăng ký
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Test đăng nhập và đăng ký",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
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
                        child: Text('Đăng nhập ngay'),
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
