import 'package:flutter/material.dart';
import 'package:hehehehe/features/auth/screens/registerScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_outlined),
        ),
        title: const Text('Login', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute<void>(
              //     builder: (context) => const RegisterScreen(),
              //   ),
              // );
            },
            child: Padding(padding: EdgeInsets.all(10), child: Text('Help')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Image(image: AssetImage('assets/icon.png'), height: 100),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF3980c3)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(right: 10),
                                  child: Icon(Icons.email_outlined),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Nhập Email của bạn',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF3980c3)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(right: 10),
                                  child: Icon(Icons.lock_outlined),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Nhập mật khẩu của bạn',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(0),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ), // chỉnh bo góc
                                    side: BorderSide(
                                      color: Color(0xFF9E9D9D),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Bạn chưa có tài khoản?'),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: true, // Giữ màn cũ hiển thị
                                      transitionDuration: const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return RegisterScreen();
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
                                child: Text(
                                  ' Đăng ký ngay',
                                  style: TextStyle(
                                    color: Color(0xFF3c81c6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(thickness: 1, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "Hoặc đăng nhập bằng",
                                  style: TextStyle(color: Color(0xFF706e6e)),
                                ),
                              ),
                              Expanded(
                                child: Divider(thickness: 1, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Đăng nhập với GG
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // chỉnh bo góc
                                  side: BorderSide(
                                    color: Color(0xFF9E9D9D),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Image(
                                    height: 30,
                                    image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Đăng nhập bằng Google',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Đăng nhập với GG
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // chỉnh bo góc
                                  side: BorderSide(
                                    color: Color(0xFF9E9D9D),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Image(
                                    height: 30,
                                    image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/2048px-2021_Facebook_icon.svg.png',
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Đăng nhập bằng Facebook',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
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
      )
    );
  }
}
