import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';

class AccountNewAddress extends StatefulWidget {
  const AccountNewAddress({super.key});

  @override
  State<AccountNewAddress> createState() => _AccountNewAddressState();
}

class _AccountNewAddressState extends State<AccountNewAddress> {
  final User? user = FirebaseAuth.instance.currentUser;

  final hoVaTenController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        title: const Text("Thêm địa chỉ", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 10,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFFbcb9b9),
                  )
                ),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Địa chỉ (dùng thông tin trước sáp nhập)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: hoVaTenController,
                          decoration: InputDecoration(
                            hintText: 'Họ và tên',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // Màu viền khi focus (đang nhập)
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextField(
                          controller: phoneNumController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Số điện thoại người nhận',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // Màu viền khi focus (đang nhập)
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Địa chỉ',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // Màu viền khi focus (đang nhập)
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Ghi chú',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // Màu viền khi focus (đang nhập)
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  surfaceTintColor: WidgetStatePropertyAll(
                    Color(0xFF3c81c6),
                  ),
                  overlayColor: WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xFFbcb9b9))
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(0),
                ),
                onPressed: () async {
                  if (hoVaTenController.text.isEmpty || phoneNumController.text.isEmpty || addressController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Vui lòng nhập đầy đủ thông tin",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  } else {
                    EasyLoading.show(status: 'Đang thêm địa chỉ...', maskType: EasyLoadingMaskType.black,);

                    try {
                      AuthServices authServices = AuthServices();
                      await authServices.addAddress(user!.uid, hoVaTenController.text, phoneNumController.text, addressController.text, noteController.text);

                      await Future.delayed(Duration(seconds: 1));
                      EasyLoading.showSuccess('Thành công ùi',maskType: EasyLoadingMaskType.clear);
                      await Future.delayed(Duration(milliseconds: 500));
                      Navigator.pop(context);
                    } catch (e) {
                      EasyLoading.showError('Có lỗi xảy ra: $e');
                    } finally {
                      EasyLoading.dismiss();
                    }
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    child: Text('Hoàn thành',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3c81c6),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
