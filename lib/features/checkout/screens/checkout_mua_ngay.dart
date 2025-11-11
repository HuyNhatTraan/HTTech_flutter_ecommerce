import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/features/checkout/screens/checkout_success.dart';
import 'package:hehehehe/features/product/screens/product_info.dart';
import 'package:hehehehe/globals.dart' as globals;

class CheckoutMuaNgay extends StatefulWidget {
  final String anhPreview;
  final String maSP;
  final String maVariantSP;
  final String tenSP;
  final String giaSP;
  final String thuocTinhSP;
  final List<Map<String, dynamic>> danhSachSanPham;
  final int soLuong;

  const CheckoutMuaNgay({
    super.key,
    required this.anhPreview,
    required this.maSP,
    required this.maVariantSP,
    required this.tenSP,
    required this.giaSP,
    required this.thuocTinhSP,
    required this.danhSachSanPham,
    required this.soLuong
  });
  @override
  State<CheckoutMuaNgay> createState() => _CheckoutMuaNgayState();
}

class _CheckoutMuaNgayState extends State<CheckoutMuaNgay> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();

  late int tongTienHeHe = int.parse(widget.giaSP) * widget.soLuong;

  String? _selectedThanhToan = 'COD';
  String? _selectedGiaoHang = 'Hoả tốc';
  String? selectedDocIDAddress;

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
                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          height: 200,
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
                                            item['HoVaTen'] + ' | ' + item['SDT'],
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
                  padding: EdgeInsetsGeometry.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Text('Sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                                print('Đã ấn ' + widget.maSP);
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
                                      maSanPham: widget.maSP,
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
                                '${globals.baseUri}/${widget.anhPreview}',
                                height: 80,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Đã ấn ' + widget.maSP);
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
                                        maSanPham: widget.maSP,
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
                                        widget.tenSP ?? "",
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Phân loại: ${widget.thuocTinhSP}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            widget.giaSP.toVND(),
                                            style: const TextStyle(
                                              color: Color(0xFF3c81c6),
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Số lượng: ${widget.soLuong}',
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
                  ),
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
                  tongTienHeHe.toVND(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3c81c6),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Fix this thingy
                    authService.addOrderForUser(user!.uid, _selectedThanhToan.toString(), _selectedGiaoHang.toString(), widget.anhPreview, selectedDocIDAddress.toString(), widget.danhSachSanPham);
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
                          Row(
                            spacing: 3,
                            children: [
                              Image(
                                image: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/960px-Visa_Inc._logo.svg.png',
                                ),
                                width: 40,
                              ),
                              Image(
                                image: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/MasterCard_early_1990s_logo.svg/250px-MasterCard_early_1990s_logo.svg.png',
                                ),
                                width: 40,
                              ),
                              Image(
                                image: NetworkImage(
                                  'https://camo.githubusercontent.com/b624142eb1373b5f2b06067da2427c6386d90d17519aee75ad69d2b8baefee59/68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f7461736b6d616e616765726561676c6f623132332f696d6167652f75706c6f61642f76313634313937303939352f5669657451522e34366137386362625f7574777a7a682e706e67',
                                ),
                                width: 40,
                              ),
                              Image(
                                image: NetworkImage(
                                  'https://e7.pngegg.com/pngimages/157/1005/png-clipart-ucb-logo-jcb-co-ltd-logo-payment-credit-card-card-vetor-text-service-thumbnail.png',
                                ),
                                width: 40,
                              ),
                            ],
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
