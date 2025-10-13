// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Lấy thông tin giỏ hàng bằng uid người dùng
  Future<List<Map<String, dynamic>>> getCart(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Thêm giỏ hàng
  Future addCart(String uid, String MaSP, String TenSP, String GiaSP, String MaVarientSanPham, String HinhAnhVariant, int SoLuong) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .doc(MaVarientSanPham)
        .set({
      "MaSP" : MaSP,
      "TenSP" : TenSP,
      "GiaSP": GiaSP,
      "MaVarientSanPham": MaVarientSanPham,
      "HinhAnhVariant": HinhAnhVariant,
      "SoLuong": FieldValue.increment(SoLuong),
      "NgayThem": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Đăng ký và lưu thẳng vào Firestore via Firebase
  Future<void> registerUsers(String uid, String email) async {
    db.collection("users").doc(uid).set({
      "email": email,
      "createdAt": Timestamp.now(),
      "role": "Khách hàng",
      "TrangThai": "Đang hoạt động",
      "HangThanhVien": "Nhựa"
    });
  }

}