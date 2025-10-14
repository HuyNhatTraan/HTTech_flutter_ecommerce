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

  // Lấy thông tin users
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snapshot =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();

    return snapshot.data();
  }


  // Xoá sản phẩm trong giỏ hàng
  Future removeCartItems(String uid, String maVarientSanPham) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .doc(maVarientSanPham.toString())
        .delete(); // <- chỉ cần dòng này là đủ
  }

  // Tăng, giảm số lượng sản phẩm trong giỏ hàng
  Future updateCartQuantities(String uid, String maVarientSanPham, int num) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .doc(maVarientSanPham.toString())
        .set({
      "MaVarientSanPham": maVarientSanPham,
      "SoLuong": FieldValue.increment(num),
      "NgayThem": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Thêm giỏ hàng
  Future addCart(String uid, String maSP, String tenSP, String giaSP, String maVarientSanPham, String hinhAnhVariant, int soLuong, String thuocTinhSP) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .doc(maVarientSanPham.toString())
        .set({
      "MaSP" : maSP,
      "TenSP" : tenSP,
      "GiaSP": giaSP,
      "MaVarientSanPham": maVarientSanPham,
      "HinhAnhVariant": hinhAnhVariant,
      "SoLuong": FieldValue.increment(soLuong),
      "NgayThem": FieldValue.serverTimestamp(),
      "ThuocTinhSP": thuocTinhSP
    }, SetOptions(merge: true));
  }

  // Đăng ký và lưu thẳng vào Firestore via Firebase
  Future<void> registerUsers(String uid, String email, String name) async {
    db.collection("users").doc(uid).set({
      "name": name.toString(),
      "email": email.toString(),
      "createdAt": Timestamp.now(),
      "role": "Khách hàng",
      "TrangThai": "Đang hoạt động",
      "HangThanhVien": "Nhựa",
      "AvatarUrl" : "assets/account/images/474621319_122198072636131249_4305780536062375088_n.jpg"
    });
  }
}