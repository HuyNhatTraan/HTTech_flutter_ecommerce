import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/account/screens/account_new_address.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/features/checkout/screens/checkout_success.dart';
import 'package:hehehehe/features/product/screens/product_info.dart';
import 'package:hehehehe/globals.dart' as globals;

class CheckoutGioHang extends StatefulWidget {
  final String anhPreview;
  const CheckoutGioHang({super.key, required this.anhPreview});

  @override
  State<CheckoutGioHang> createState() => _CheckoutGioHangState();
}

class _CheckoutGioHangState extends State<CheckoutGioHang> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();

  int tongTienHeHe = 0; // biến tổng tiền toàn cục cho State

  String? _selectedThanhToan = 'COD';
  String? _selectedGiaoHang = 'Hoả tốc';
  String? selectedDocIDAddress;
  bool isHaveAddress = false;

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
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: user == null
          ? _buildLoginPrompt(context)
          : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsetsGeometry.only(left: 15, right: 15, top: 15),
                  child: Text('Địa chỉ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ),
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
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
                    isHaveAddress = true;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 5.6,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index].data() as Map<String, dynamic>;
                          final docID = snapshot.data!.docs[index].id;

                          if (items.isNotEmpty && selectedDocIDAddress == null) {
                            selectedDocIDAddress = items.first.id;
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDocIDAddress = docID;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selectedDocIDAddress == docID
                                      ? Color(0xFF3c81c6)
                                      : const Color(0xFFadadad),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Radio ở bên trái
                                  Transform.translate(
                                    offset: const Offset(-10, 0),
                                    child: Radio<String>(
                                      value: docID,
                                      groupValue: selectedDocIDAddress,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDocIDAddress = value;
                                          print(selectedDocIDAddress);
                                        });
                                        Fluttertoast.showToast(
                                          msg: "Đã chọn: $docID",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.white,
                                        );
                                      },
                                      activeColor: Color(0xFF3c81c6),
                                    ),
                                  ),
                            
                                  // Nội dung bên phải
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 4,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${item['HoVaTen']} | ${item['SDT']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item['Address'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF1d1e1f),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      surfaceTintColor: WidgetStatePropertyAll(Color(0xFF3c81c6)),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey),
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
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      child: Text(
                        'Thêm địa chỉ ngay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3c81c6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Text('Sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                        .collection('cart')
                        .doc(user!.uid)
                        .collection('SanPham')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
            
                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      }
            
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
            
                      // Tính tổng tiền
                      int tong = 0;
                      final items = snapshot.data!.docs;
                      for (var doc in items) {
                        final gia = int.tryParse(doc['GiaSP'].toString()) ?? 0;
                        final soLuong = int.tryParse(doc['SoLuong'].toString()) ?? 0;
            
                        tong += gia * soLuong;
                      }
            
                      // cập nhật vào biến state cho bottomNav
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (tongTienHeHe != tong) {
                          setState(() => tongTienHeHe = tong);
                        }
                      });
            
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item =
                                  items[index].data() as Map<String, dynamic>;
                              final GiaSP = item["GiaSP"].toString();
                              final SoLuong = item["SoLuong"];
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
                                            print('Đã ấn ${item["MaSP"]}');
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
                                            height: 80,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              print('Đã ấn ${item["MaSP"]}');
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        GiaSP.toVND(),
                                                        style: const TextStyle(
                                                          color: Color(0xFF3c81c6),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Số lượng: $SoLuong',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
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
                        ],
                      );
                    },
                  ),
                _radioOption(context),
              ],
            ),
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
                  onPressed: () async {
                    EasyLoading.show(status: 'Đợi tý nhen...', maskType: EasyLoadingMaskType.black);
                    await Future.delayed(Duration(seconds: 1));

                    if (isHaveAddress == false) {
                      EasyLoading.showError('Vui lòng thêm / chọn địa chỉ', maskType: EasyLoadingMaskType.black);
                      return;
                    }
                    authService.moveCartToOrders(user!.uid, _selectedThanhToan.toString(), _selectedGiaoHang.toString(), widget.anhPreview, selectedDocIDAddress.toString());
                    EasyLoading.showSuccess('Thành công ùi!');
                    await Future.delayed(Duration(seconds: 1));
                    EasyLoading.dismiss();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutSuccess(),
                      ),
                    );

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
                    'Đặt hàng',
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

  Widget _radioOption(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phương thức thanh toán',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'COD',
                      groupValue: _selectedThanhToan,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedThanhToan = value;
                        });
                      },
                      activeColor: Color(0xFF3c81c6),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedThanhToan = 'COD';
                        });
                      },
                      child: Text(
                        'Thanh toán khi nhận hàng (COD)',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'ATM',
                      groupValue: _selectedThanhToan,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedThanhToan = value;
                        });
                      },activeColor: Color(0xFF3c81c6),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedThanhToan = 'ATM';
                        });
                      },
                      child: Text('Chuyển khoản ngân hàng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hình thức giao hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Hoả tốc',
                      groupValue: _selectedGiaoHang,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGiaoHang = value;
                        });
                      },activeColor: Color(0xFF3c81c6),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGiaoHang = 'Hoả tốc';
                        });
                      },
                      child: Text('Hoả tốc (nội thành)'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Nhận hàng tại cửa hàng',
                      groupValue: _selectedGiaoHang,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGiaoHang = value;
                        });
                      },activeColor: Color(0xFF3c81c6),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGiaoHang =
                          'Nhận hàng tại cửa hàng';
                        });
                      },
                      child: Text('Nhận hàng tại cửa hàng'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Giao nhanh',
                      groupValue: _selectedGiaoHang,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGiaoHang = value;
                        });
                      },activeColor: Color(0xFF3c81c6),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGiaoHang = 'Giao nhanh';
                          });
                        },
                        child: Text(
                          'Nhanh (1-3 ngày khu vục TPHCM, 3-6 ngày cho các khu vực khác)',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tại sao nên mua tại HT Tech',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  spacing: 15,
                  children: [
                    Icon(
                      Icons.airport_shuttle_outlined,
                      size: 40,
                    ),
                    Expanded(
                      child: Column(
                        spacing: 3,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giao hàng nhanh',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'HCM và khu vục phía Nam: Giao hàng từ 1 - 3 ngày làm việc. Các khu vực khác giao hàng từ 3 - 6 ngày làm việc.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  spacing: 15,
                  children: [
                    Icon(Icons.restart_alt_outlined, size: 40),
                    Expanded(
                      child: Column(
                        spacing: 3,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dịch vụ sau bán hàng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Hỗ trợ đổi trả trong vòng 14 ngày do các vấn đề do nhà sản xuất.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  spacing: 15,
                  children: [
                    Icon(Icons.credit_card_outlined, size: 40),
                    Expanded(
                      child: Column(
                        spacing: 3,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thanh toán an toàn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Thanh toán an toàn & bảo mật. Dễ dàng và nhanh chóng.',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            child: Row(
                              spacing: 3,
                              children: [
                                Image(
                                  image: AssetImage(
                                    'assets/Visa_Inc._logo.svg.png',
                                  ),
                                  width: 40,
                                ),
                                Image(
                                  image: AssetImage(
                                    'assets/MasterCard_early_1990s_logo.svg.png',
                                  ),
                                  width: 40,
                                ),
                                Image(
                                  image: AssetImage(
                                    'assets/VietQR.png',
                                  ),
                                  width: 40,
                                ),
                                Image(
                                  image: AssetImage(
                                    'assets/png-clipart-ucb-logo-jcb-co-ltd-logo-payment-credit-card-card-vetor-text-service-thumbnail.png',
                                  ),
                                  width: 40,
                                ),
                              ],
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
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
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
            'Vui lòng đăng nhập.',
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
