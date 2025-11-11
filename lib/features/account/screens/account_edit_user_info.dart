import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';
import 'package:hehehehe/globals.dart' as globals;

class AccountEditUserInfo extends StatefulWidget {
  const AccountEditUserInfo({super.key});

  @override
  State<AccountEditUserInfo> createState() => _AccountEditUserInfoState();
}

class _AccountEditUserInfoState extends State<AccountEditUserInfo> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthServices authService = AuthServices();

  final nameController = TextEditingController();
  final phoneNumController = TextEditingController();

  final ValueNotifier<String> errorNumText = ValueNotifier('');

  bool isValidVNPhone(String? value) {
    if (value == null || value.trim().isEmpty) return false;

    // Bỏ khoảng trắng, dấu chấm, gạch nối
    final cleaned = value.replaceAll(RegExp(r'[\s\.\-]'), '');

    // Regex cho số điện thoại Việt Nam
    final pattern = r'^(?:0[35789]\d{8}|(?:\+84|84)[35789]\d{8})$';
    final regex = RegExp(pattern);

    return regex.hasMatch(cleaned);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: authService.getUser(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không tìm thấy thông tin người dùng"));
            }

            nameController.text = snapshot.data!['name'];
            phoneNumController.text = snapshot.data!['sdt'] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Họ và tên', style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 28,
                            ),
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Nhập tên của bạn',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('Số điện thoại', style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 28,
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isEmpty || phoneNumController.text.isEmpty) {
                                    errorNumText.value = 'Vui lòng nhập số điện thoại';
                                  } else if (!isValidVNPhone(value)) {
                                    errorNumText.value = 'Số điện thoại không hợp lệ';
                                    print (errorNumText.value);
                                  } else {
                                    errorNumText.value = '';
                                  }
                                },
                                controller: phoneNumController,
                                decoration: const InputDecoration(
                                  hintText: 'Nhập số điện thoại của bạn',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: errorNumText,
                          builder: (context, error, _) {
                            return Text(
                              error,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                    child: ElevatedButton(
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
                              side: BorderSide(color: Colors.grey)
                          ),
                        ),
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      onPressed: () async {
                        if (errorNumText.value == 'Số điện thoại không hợp lệ' || errorNumText.value == 'Vui lòng nhập số điện thoại') {
                          EasyLoading.showError('Vui lòng đúng và đẩy đủ thông tin');
                          await Future.delayed(Duration(seconds: 1));
                          EasyLoading.dismiss();
                        } else {
                          EasyLoading.show(status: 'Đang cập nhật...', maskType: EasyLoadingMaskType.black,);

                          try {
                            await authService.editUser(
                              user!.uid,
                              nameController.text,
                              phoneNumController.text,
                            );

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
                          child: Text('Chỉnh sửa ngay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF3c81c6),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
