import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading, EasyLoadingMaskType;
import 'package:hehehehe/features/account/screens/account_support.dart';
import 'package:hehehehe/features/auth/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // Dùng phương thức .hasMatch() để kiểm tra xem email có khớp khuôn không
    return emailRegExp.hasMatch(email);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  String _emailErrorText = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_outlined),
        ),
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AccountSupport(),
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
              child: Padding(padding: EdgeInsets.all(10), child: Text('Help')),
            ),
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
                              color: Colors.white
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(right: 10),
                                  child: Icon(Icons.email_outlined),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: emailController,
                                    onChanged: (text) {
                                      if (isEmailValid(text)) {
                                        _emailErrorText = ' ';
                                      } else {
                                        _emailErrorText = 'Email không hợp lệ';
                                      }
                                    },
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
                          Text(
                            _emailErrorText.toString(),
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                          SizedBox(height: 5),
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
                                color: Colors.white
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // cho icon và textfield thẳng hàng
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.lock_outlined),
                                ),
                                Expanded(
                                  child: TextField(
                                    obscureText: _obscureText,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 18, // chỉnh size nhỏ cho cân
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                      hintText: 'Nhập mật khẩu của bạn',
                                      border: InputBorder.none,
                                      isDense: true, // giúp textfield gọn lại
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ), // căn giữa text
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(0),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
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
                              onPressed: () async {
                                if (passwordController.text.isEmpty ||
                                    emailController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Vui lòng nhập đầy đủ thông tin.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFF3a81c4),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  return;
                                }
                                if (_emailErrorText == 'Email không hợp lệ') {
                                  Fluttertoast.showToast(
                                    msg: "Vui lòng nhập email hợp lệ.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFF3a81c4),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  return;
                                }
                                EasyLoading.show(status: 'Đợi tý nhen...', maskType: EasyLoadingMaskType.black,);

                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text
                                        .trim(),
                                  );

                                  await Future.delayed(Duration(seconds: 1));
                                  EasyLoading.showSuccess('Đăng nhập thành công',maskType: EasyLoadingMaskType.clear);
                                  await Future.delayed(Duration(milliseconds: 500));
                                  Navigator.popUntil(context, (route) => route.isFirst);

                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Fluttertoast.showToast(
                                      msg: "Không tìm thấy tài khoản này",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xFF3a81c4),
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else if (e.code == 'wrong-password' ||
                                      e.code == 'invalid-credential') {
                                    Fluttertoast.showToast(
                                      msg:
                                      "Sai mật khẩu hoặc tài khoản. Vui lòng thử lại",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: Color(0xFF3a81c4),
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                }
                                catch (e) {
                                  EasyLoading.showError('Có lỗi xảy ra: $e');
                                  print (e);
                                } finally {
                                  EasyLoading.dismiss();
                                }
                                // try {
                                //   await FirebaseAuth.instance
                                //       .signInWithEmailAndPassword(
                                //         email: emailController.text.trim(),
                                //         password: passwordController.text
                                //             .trim(),
                                //       );
                                //
                                //   Fluttertoast.showToast(
                                //     msg: "Đăng nhập thành công",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor: Color(0xFF3a81c4),
                                //     textColor: Colors.white,
                                //     fontSize: 16.0,
                                //   );
                                //
                                //   Navigator.of(context).popUntil((route) => route.isFirst);
                                // } on FirebaseAuthException catch (e) {
                                //   if (e.code == 'user-not-found') {
                                //     Fluttertoast.showToast(
                                //       msg: "Không tìm thấy tài khoản này",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Color(0xFF3a81c4),
                                //       textColor: Colors.white,
                                //       fontSize: 16.0,
                                //     );
                                //   } else if (e.code == 'wrong-password' ||
                                //       e.code == 'invalid-credential') {
                                //     Fluttertoast.showToast(
                                //       msg:
                                //           "Sai mật khẩu hoặc tài khoản. Vui lòng thử lại",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 2,
                                //       backgroundColor: Color(0xFF3a81c4),
                                //       textColor: Colors.white,
                                //       fontSize: 16.0,
                                //     );
                                //   }
                                // }
                              },
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: true, // Giữ màn cũ hiển thị
                                      transitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) {
                                            return RegisterScreen();
                                          },
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            final tween =
                                                Tween(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).chain(
                                                  CurveTween(
                                                    curve: Curves.easeInOutSine,
                                                  ),
                                                );

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
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
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
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Đăng nhập với GG
                          ElevatedButton(
                            onPressed: () async {
                              AuthServices authServices = AuthServices();
                              final userCredential = await authServices.signInWithGoogle();
                              if (userCredential != null) {
                                Fluttertoast.showToast(
                                    msg: "Đăng nhập thành công",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFFd2f5fc),
                                    textColor: Color(0xFF3c81c6),
                                    fontSize: 16.0
                                );
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                print("Đăng nhập thành công: ${userCredential.user?.displayName}");
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Người dùng đã huỷ hoặc lỗi.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFFd2f5fc),
                                    textColor: Color(0xFF3c81c6),
                                    fontSize: 16.0
                                );
                                print("Người dùng đã huỷ hoặc lỗi.");
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
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
                                    image: AssetImage('assets/768px-Google_22G22_logo.svg.png')
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
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 0, // chỉnh độ cao shadow
                                  backgroundColor: Color(0xFFd4f6ff),
                                  content: const Text(
                                    'Tính năng này đang được xây dựng thử lại sau hen',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  width: 320.0, // Width of the SnackBar.
                                  padding: const EdgeInsets.all(20),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(
                                      color: Color(0xFF706e6e),
                                      width: 0.3,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
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
                                    image: AssetImage('assets/2048px-2021_Facebook_icon.svg.jpg')
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
      ),
    );
  }
}
