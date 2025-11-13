import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // nhớ import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/features/checkout/screens/checkout_gio_hang.dart';
import 'package:hehehehe/features/product/screens/product_info.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';
import 'package:hehehehe/globals.dart' as globals;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();
  bool isEmptyCart = true;

  int tongTienHeHe = 0;
  String anhPreview = '';
  int cartNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_backspace_outlined),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Giỏ hàng ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '(${cartNum.toString()})',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
      body: user == null
          ? _buildLoginPrompt(context)
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .doc(user!.uid)
                  .collection('SanPham')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  isEmptyCart = true;
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print('Trạng thái giỏ hàng' + isEmptyCart.toString());
                  isEmptyCart = true;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.production_quantity_limits_outlined,
                          size: 64,
                          color: Color(0xFF3c81c6),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Giỏ hàng trống',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF3c81c6),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFD2F5FC),
                            foregroundColor: const Color(0xFF3C81C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color(0xFF3C81C6),
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Tiếp tục mua hàng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                isEmptyCart = false;
                // Tính tổng tiền
                int tong = 0;
                final items = snapshot.data!.docs;
                int tempCartNum = 0;
                for (var doc in items) {
                  final gia = int.tryParse(doc['GiaSP'].toString()) ?? 0;
                  final soLuong = int.tryParse(doc['SoLuong'].toString()) ?? 0;
                  tempCartNum += soLuong;
                  tong += gia * soLuong;
                }

                cartNum = tempCartNum;

                // cập nhật vào biến state cho bottomNav
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (tongTienHeHe != tong) {
                    setState(() {
                      tongTienHeHe = tong;
                    });
                  }
                });

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item =
                              items[index].data() as Map<String, dynamic>;
                          final giaSP = item["GiaSP"].toString();
                          var soLuong = item["SoLuong"];
                          anhPreview = '/${item["HinhAnhVariant"]}';

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('Đã ấn ' + item["MaSP"]);
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => ProductInfo(
                                                  maSanPham: item["MaSP"],
                                                ),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  final tween =
                                                      Tween(
                                                        begin: const Offset(
                                                          1,
                                                          0,
                                                        ),
                                                        end: Offset.zero,
                                                      ).chain(
                                                        CurveTween(
                                                          curve: Curves
                                                              .easeInOutSine,
                                                        ),
                                                      );
                                                  return SlideTransition(
                                                    position: animation.drive(
                                                      tween,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        '${globals.baseUri}/${item["HinhAnhVariant"]}',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Đã ấn ' + item["MaSP"]);
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) => ProductInfo(
                                                    maSanPham: item["MaSP"],
                                                  ),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    final tween =
                                                        Tween(
                                                          begin: const Offset(
                                                            1,
                                                            0,
                                                          ),
                                                          end: Offset.zero,
                                                        ).chain(
                                                          CurveTween(
                                                            curve: Curves
                                                                .easeInOutSine,
                                                          ),
                                                        );
                                                    return SlideTransition(
                                                      position: animation.drive(
                                                        tween,
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                item["TenSP"] ?? "",
                                                maxLines: 3,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Phân loại: ${item["ThuocTinhSP"]}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                giaSP.toVND(),
                                                style: const TextStyle(
                                                  color: Color(0xFF3c81c6),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      spacing: 10,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (soLuong == 1) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Xác nhận"),
                                                        content: Text(
                                                          "Người anh em có chắc muốn xóa không?",
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                ),
                                                            child: Text("Hủy"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              authService
                                                                  .removeCartItems(
                                                                    user!.uid,
                                                                    item["MaVarientSanPham"],
                                                                  );
                                                              setState(() {
                                                                isEmptyCart =
                                                                    true;
                                                                cartNum = 0;
                                                              });
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text("Xóa"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  if (soLuong == 0 ||
                                                      soLuong < 0) {
                                                    return;
                                                  }
                                                  authService
                                                      .updateCartQuantities(
                                                        user!.uid,
                                                        item["MaVarientSanPham"],
                                                        -1,
                                                      );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding: const EdgeInsets.all(
                                                    10.0,
                                                  ),
                                                  child: const Icon(
                                                    Icons.remove_outlined,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                child: TextField(
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly,
                                                  ],
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      TextEditingController(
                                                        text: soLuong.toString(),
                                                      ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                      ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSubmitted: (value) {
                                                    if (value.isEmpty) {
                                                      int tempSoLuong = soLuong;
                                                      print(tempSoLuong);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text(
                                                            "Xác nhận",
                                                          ),
                                                          content: Text(
                                                            "Người anh em có chắc muốn xóa không?",
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context,);
                                                                setState(() {
                                                                  soLuong = tempSoLuong;
                                                                });
                                                              },
                                                              child: Text(
                                                                "Hủy",
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                authService
                                                                    .removeCartItems(
                                                                      user!.uid,
                                                                      item["MaVarientSanPham"],
                                                                    );
                                                                setState(() {
                                                                  isEmptyCart =
                                                                      true;
                                                                  cartNum = 0;
                                                                });
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text(
                                                                "Xóa",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      authService
                                                          .updateCartQuantitiesByInput(
                                                            user!.uid,
                                                            item["MaVarientSanPham"],
                                                            int.parse(value),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  authService
                                                      .updateCartQuantities(
                                                        user!.uid,
                                                        item["MaVarientSanPham"],
                                                        1,
                                                      );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  child: const Icon(
                                                    Icons.add_outlined,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Xác nhận"),
                                                content: Text(
                                                  "Người anh em có chắc muốn xóa không?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Hủy"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      authService.removeCartItems(
                                                        user!.uid,
                                                        item["MaVarientSanPham"],
                                                      );
                                                      setState(() {
                                                        isEmptyCart = true;
                                                        cartNum = 0;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Xóa"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Xoá",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          '---------- Có thể bạn sẽ thích ----------',
                        ),
                      ),
                      ProductCard(route: '/products'),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng cộng:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (isEmptyCart == true)
                  const Text(
                    '0 đ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3c81c6),
                    ),
                  )
                else
                  Text(
                    tongTienHeHe.toString().toVND(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3c81c6),
                    ),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    print('Trạng thái Cart: ' + isEmptyCart.toString());
                    if (isEmptyCart == false) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CheckoutGioHang(
                                    anhPreview: anhPreview.toString(),
                                  ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                final tween =
                                    Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).chain(
                                      CurveTween(curve: Curves.easeInOutSine),
                                    );
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Giỏ hàng đang trống ớ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xFFd1f4fb),
                        textColor: Color(0xFF3a81c4),
                        fontSize: 16.0,
                      );
                    }
                    ;
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD2F5FC),
                    foregroundColor: const Color(0xFF3C81C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFF3C81C6),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    setState(() {
      cartNum = 0;
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.production_quantity_limits_outlined,
            size: 64,
            color: Color(0xFF3c81c6),
          ),
          const SizedBox(height: 15),
          const Text(
            'Vui lòng đăng nhập để xem giỏ hàng.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF3c81c6),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
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
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFD2F5FC),
              foregroundColor: const Color(0xFF3C81C6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF3C81C6), width: 1),
              ),
            ),
            child: const Text('Đăng nhập ngay.'),
          ),
        ],
      ),
    );
  }
}
