import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:hehehehe/globals.dart' as globals;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/services/auth_service.dart';

class ProductVariants extends StatefulWidget {
  final String maSanPham;
  final String route;
  final String tenSanPham;
  const ProductVariants({
    super.key,
    required this.maSanPham,
    required this.route,
    required this.tenSanPham,
  });

  @override
  State<ProductVariants> createState() => _ProductVariantsState();
}

class _ProductVariantsState extends State<ProductVariants> {
  List<dynamic> _productsVariants = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _quantityController.text = _currentQuantities.toString();
  }

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải
    });
    try {
      final url = Uri.parse(
        '${globals.baseUri}${widget.route}/${widget.maSanPham}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) {
          // Kiểm tra xem widget còn trong cây widget không
          setState(() {
            _productsVariants = json.decode(response.body);
            _isLoading = false; // Tải xong
          });

          // Gọi firstSelected sau khi đã có dữ liệu và UI chưa render lại
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_productsVariants.isNotEmpty) {
              setState(() {
                _currentTempPrices = _productsVariants[0]["GiaSP"];
                _selectedVariant = _productsVariants[0]["MaVarientSanPham"]
                    .toString();
                _selectedVariantImgUrl = _productsVariants[0]["HinhAnhVariant"]
                    .toString();
                _selectedThuocTinhSP = _productsVariants[0]["ThuocTinhSP"]
                    .toString();
                _selectedTonKho = _productsVariants[0]["SoLuongSP"]
                    .toString();
              });
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false; // Tải lỗi
          });
        }
        throw Exception(
          "Failed to load products, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Tải lỗi
        });
      }
    }
  }

  int _selectedIndex = 0;
  int _currentQuantities = 1;
  String _currentTempPrices = '';
  String _selectedVariant = '';
  String _selectedVariantImgUrl = '';
  String _selectedThuocTinhSP = '';
  String _selectedTonKho = '';
  final AuthServices authService = AuthServices();

  final User? user = FirebaseAuth.instance.currentUser;

  final _quantityController = TextEditingController();


  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_productsVariants.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        Text(
                          _productsVariants[0]["LoaiSP"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Text('*Chọn màu sắc: ${_selectedThuocTinhSP.toString()}', maxLines: 2,))
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text('Còn lại: ', style: TextStyle(color: Colors.grey)),
                                Text(_selectedTonKho, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _productsVariants.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Không tìm thấy sản phẩm nào.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 95,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5
                              ),
                          itemCount: _productsVariants.length,
                          itemBuilder: (context, index) {
                            final product = _productsVariants[index];
                            final isSelected = _selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                  _currentTempPrices = product["GiaSP"];
                                  _selectedVariant =
                                      product["MaVarientSanPham"].toString();
                                  _selectedVariantImgUrl =
                                      product["HinhAnhVariant"].toString();
                                  _selectedThuocTinhSP =
                                      product["ThuocTinhSP"].toString();
                                  _selectedTonKho =
                                      product["SoLuongSP"].toString();
                                });
                                print(
                                  'Đã chọn sản phẩm: ${product["MaVarientSanPham"]} $_selectedVariant',
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : const Color(0xFF706e6e),
                                    width: isSelected ? 3 : 1,
                                  ),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Image.network(
                                  "${globals.baseUri}/${product["HinhAnhVariant"]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // ===== Bottom bar custom =====
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tạm tính:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (int.tryParse(_currentTempPrices.trim()) ?? 0)
                            .toVND()
                            .toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3c81c6),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số lượng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentQuantities--;
                                _quantityController.text = _currentQuantities.toString();
                                if (_currentQuantities < 1) {
                                  _currentQuantities = 1;
                                  _quantityController.text = _currentQuantities.toString();
                                }
                              });
                            },
                            icon: Icon(Icons.remove_outlined),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 30,
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                              decoration:
                              const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (value) {
                                int tempSoLuong = _currentQuantities;
                                if (value.isEmpty) {
                                  setState(() {
                                    _currentQuantities = tempSoLuong;
                                    _quantityController.text = tempSoLuong.toString();
                                  });
                                } else {
                                  setState(() {
                                    _currentQuantities = int.tryParse(value) ?? 1;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentQuantities++;
                                _quantityController.text = _currentQuantities.toString();
                                print(_currentQuantities);
                              });
                            },
                            icon: Icon(Icons.add_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFc3e5ff),
                      ),
                      onPressed: _selectedIndex == -1
                          ? () {
                              Fluttertoast.showToast(
                                msg: "Vui lòng chọn màu sắc",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xFF3a81c4),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          : () {
                              if (user != null) {
                                AuthServices authServices = AuthServices();
                                authServices.addCart(
                                  user!.uid,
                                  widget.maSanPham,
                                  widget.tenSanPham,
                                  _currentTempPrices.toString(),
                                  _selectedVariant,
                                  _selectedVariantImgUrl,
                                  _currentQuantities,
                                  _selectedThuocTinhSP,
                                );
                                Fluttertoast.showToast(
                                  msg: "Thêm thành công",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xFF3a81c4),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
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
                                        ) => const LoginScreen(),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          final tween =
                                              Tween(
                                                begin: const Offset(1, 0),
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
                              }
                            },
                      child: Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                          color: Color(0xFF3c81c6),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
