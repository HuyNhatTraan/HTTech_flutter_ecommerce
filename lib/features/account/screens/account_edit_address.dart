import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';

class AccountEditAddress extends StatefulWidget {
  final String docID;
  const AccountEditAddress({super.key, required this.docID});

  @override
  State<AccountEditAddress> createState() => _AccountEditAddressState();
}

class _AccountEditAddressState extends State<AccountEditAddress> {
  final User? user = FirebaseAuth.instance.currentUser;

  final hoVaTenController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa địa chỉ', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFbcb9b9),
                    )
                ),
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("address")
                      .doc(user?.uid)
                      .collection("UserAddress")
                      .doc(widget.docID)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('Không tìm thấy dữ liệu.'));
                    }

                    final items = snapshot.data!.data() as Map<String, dynamic>;

                    // Gán dữ liệu cho controller
                    hoVaTenController.text = items['HoVaTen'] ?? '';
                    phoneNumController.text = items['SDT'] ?? '';
                    addressController.text = items['Address'] ?? '';
                    noteController.text = items['Notes'] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        const Text(
                          'Địa chỉ (dùng thông tin trước sáp nhập)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: hoVaTenController,
                              decoration: const InputDecoration(
                                hintText: 'Họ và tên',
                                hintStyle: TextStyle(
                                  fontSize: 12,
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
                            TextField(
                              controller: phoneNumController,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Số điện thoại người nhận',
                                hintStyle: TextStyle(
                                  fontSize: 12,
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
                            TextField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                hintText: 'Địa chỉ',
                                hintStyle: TextStyle(
                                  fontSize: 12,
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
                            TextField(
                              controller: noteController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'Ghi chú',
                                hintStyle: TextStyle(
                                  fontSize: 12,
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
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
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
                            side: BorderSide(color: Colors.grey)
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
                        AuthServices authServices = AuthServices();
                        await authServices.editAddress(user!.uid, hoVaTenController.text, phoneNumController.text, addressController.text, noteController.text, widget.docID,);
                        Future.delayed(Duration(milliseconds: 500), () {
                          Fluttertoast.showToast(
                              msg: "Chỉnh sửa thành công",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        });
                        Future.delayed(Duration(milliseconds: 1500), () {
                          Navigator.pop(context);
                        });
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
                            side: BorderSide(color: Colors.grey)
                        ),
                      ),
                      elevation: WidgetStatePropertyAll(0),
                    ),
                    onPressed: () async {
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Hủy",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                AuthServices authServices = AuthServices();
                                await authServices.deleteAddress(user!.uid, widget.docID);

                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Xoá thành công",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFFd2f5fc),
                                    textColor: Color(0xFF3c81c6),
                                    fontSize: 16.0
                                );
                              },
                              child: Text(
                                "Xóa",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        child: Text('Xoá địa chỉ này',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
