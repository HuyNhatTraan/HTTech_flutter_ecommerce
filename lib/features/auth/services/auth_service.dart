import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hehehehe/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Lấy thông tin người dùng
  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      // Tham chiếu đến collection "users"
      final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
      final snapshot = await docRef.get();

      // Nếu user đã có trong Firestore
      if (snapshot.exists) {
        return snapshot.data();
      }

      // Nếu chưa có (ví dụ user đăng nhập bằng Google)
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Kiểm tra xem provider có phải Google không
        final isGoogleUser = user.providerData.any((p) => p.providerId == 'google.com');

        if (isGoogleUser) {
          final googleUserData = {
            'uid': user.uid,
            'name': user.displayName ?? 'Người dùng Google',
            'email': user.email ?? '',
            "sdt":'',
            "createdAt": Timestamp.now(),
            'AvatarUrl': user.photoURL ?? '',
            'HangThanhVien': 'Nhựa',
            'provider': 'google',
          };

          // (Tuỳ chọn) Tự động lưu vào Firestore nếu chưa có
          await docRef.set(googleUserData, SetOptions(merge: true));

          return googleUserData;
        }
      }

      // Nếu không tìm thấy user
      return null;
    } catch (e) {
      print('Lỗi khi lấy thông tin user: $e');
      return null;
    }
  }

  // Chỉnh sửa thông tin người dùng
  Future<void> editUser(String uid, String name, String phoneNum,) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "name": name,
        "sdt": phoneNum,
      }, SetOptions(merge: true));

    } catch (e) {
      Fluttertoast.showToast(
          msg: "Đã có lỗi xảy ra. Lỗi: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFd2f5fc),
          textColor: Color(0xFF3c81c6),
          fontSize: 16.0
      );
    }
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

  Future updateCartQuantitiesByInput(String uid, String maVarientSanPham, int num) async {
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(uid)
        .collection("SanPham")
        .doc(maVarientSanPham.toString())
        .set({
      "MaVarientSanPham": maVarientSanPham,
      "SoLuong": num,
      "NgayThem": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addOrderForUser(
    String uid,
    String phuongThucThanhToan,
    String hinhThucGiaoHang,
    String imagePreview,
    String maDiaChi,
    List<Map<String, dynamic>> danhSachSanPham,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final orderCollection = firestore.collection('orders');

    // Tạo tài liệu đơn hàng mới
    final newOrderDoc = orderCollection.doc();
    final orderId = newOrderDoc.id;

    // Dữ liệu đơn hàng
    final orderData = {
      "UserID": uid,
      "OrderID": orderId,
      "PhuongThucThanhToan": phuongThucThanhToan,
      "HinhThucGiaoHang": hinhThucGiaoHang,
      "AnhDonHang": imagePreview,
      "NgayDatHang": FieldValue.serverTimestamp(),
      "MaDiaChi": maDiaChi,
      "TrangThai": "Đang xử lý",
    };

    // Batch để ghi dữ liệu
    final batch = firestore.batch();

    // Ghi dữ liệu đơn hàng
    batch.set(newOrderDoc, orderData);

    // Ghi từng sản phẩm vào subcollection "SanPham"
    for (var sanPham in danhSachSanPham) {
      final maVarient = sanPham["MaVarientSanPham"];
      final spDoc = newOrderDoc.collection("SanPham").doc(maVarient);

      batch.set(spDoc, {
        "MaSP": sanPham["MaSP"],
        "TenSP": sanPham["TenSP"],
        "GiaSP": sanPham["GiaSP"],
        "MaVarientSanPham": maVarient,
        "HinhAnhVariant": sanPham["HinhAnhVariant"],
        "SoLuong": FieldValue.increment(sanPham["SoLuong"]),
        "NgayThem": FieldValue.serverTimestamp(),
        "ThuocTinhSP": sanPham["ThuocTinhSP"],
      });
    }

    await batch.commit();
  }

  // Chuyển giỏ hàng sang đơn hàng và xoá đơn hàng cũ
  Future<void> moveCartToOrders(String uid, String phuongThucThanhToan, String hinhThucGiaoHang, String imagePreview, String maDiaChi) async {
    final firestore = FirebaseFirestore.instance;
    final cartRef = firestore.collection('cart').doc(uid).collection('SanPham');
    final orderRef = firestore.collection('orders');

    // Lấy tất cả sản phẩm trong giỏ
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.docs.isEmpty) {
      print("Giỏ hàng trống!");
      return;
    }

    // Tạo id đơn hàng mới
    final newOrderDoc = orderRef.doc();
    final orderId = newOrderDoc.id;

    // Tạo dữ liệu đơn hàng
    final orderData = {
      "UserID": uid,
      "OrderID": orderId,
      "PhuongThucThanhToan": phuongThucThanhToan,
      "HinhThucGiaoHang": hinhThucGiaoHang,
      "AnhDonHang" : imagePreview,
      "NgayDatHang": FieldValue.serverTimestamp(),
      "MaDiaChi": maDiaChi,
      "TrangThai": "Đang xử lý",
    };

    // Ghi đơn hàng mới
    await newOrderDoc.set(orderData);

    // Thêm toàn bộ sản phẩm từ cart sang orders
    final batch = firestore.batch();

    for (var doc in cartSnapshot.docs) {
      final spRef = newOrderDoc.collection("SanPham").doc(doc.id);
      batch.set(spRef, doc.data());
    }

    // Xoá toàn bộ giỏ hàng
    for (var doc in cartSnapshot.docs) {
      batch.delete(cartRef.doc(doc.id));
    }

    await batch.commit();
  }

    // Đăng nhập với GG
    Future<UserCredential?> signInWithGoogle() async {
      try {
        // B1: Gọi hộp thoại chọn tài khoản Google
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) return null; // Người dùng ấn Cancel

        // B2: Lấy token xác thực
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // B3: Tạo credential cho Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        registerUser(googleUser.email, user!.uid, googleUser.displayName!, "Google");
        // B4: Đăng nhập vào Firebase
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        print('Lỗi đăng nhập Google: $e');
        return null;
      }
    }

  // Đăng xứt khỏi GG
  Future<void> signOutGoogle() async {
    try {
      // Đăng xuất khỏi Google Sign-In
      await GoogleSignIn().signOut();

      // Đăng xuất khỏi Firebase
      await FirebaseAuth.instance.signOut();

      print('Đăng xuất Google thành công!');
    } catch (e) {
      print('Lỗi khi đăng xuất Google: $e');
    }
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

  // Thêm địa chỉ
  Future addAddress(String uid, String hoVaTen, String phoneNum, String address, String note) async {
    await FirebaseFirestore.instance
        .collection("address")
        .doc(uid)
        .collection("UserAddress")
        .doc()
        .set({
      "HoVaTen": hoVaTen,
      "SDT": phoneNum,
      "Address": address,
      "Notes": note,
      "NgayThem": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Xoá địa chỉ
  Future deleteAddress(String uid, String docID) async {
    await FirebaseFirestore.instance
        .collection("address")
        .doc(uid)
        .collection("UserAddress")
        .doc(docID)
        .delete();
  }

  // Chỉnh sửa địa chỉ
  Future editAddress(String uid, String hoVaTen, String phoneNum, String address, String note, String docID) async {
    await FirebaseFirestore.instance
        .collection("address")
        .doc(uid)
        .collection("UserAddress")
        .doc(docID)
        .set({
      "HoVaTen": hoVaTen,
      "SDT": phoneNum,
      "Address": address,
      "Notes": note,
      "NgayThem": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Đăng ký vào DB Local
  Future<void> registerUser(String email, String maTaiKhoan, String tenKH, String loginMethod) async {
    final url = Uri.parse('$baseUri/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'maTaiKhoan': maTaiKhoan,
          'tenKH': tenKH,
          'loginMethod': loginMethod,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ ${data['alert']}');
      } else {
        print('⚠️ Lỗi server: ${response.statusCode}');
        print('Chi tiết: ${response.body}');
      }
    } catch (e) {
      print('❌ Lỗi kết nối: $e');
    }
  }

  // Đăng ký và lưu thẳng vào Firestore via Firebase
  Future<void> registerToFirebaseEmail(String uid, String email, String name) async {
    db.collection("users").doc(uid).set({
      "name": name.toString(),
      "email": email.toString(),
      "sdt":'',
      "createdAt": Timestamp.now(),
      "role": "Khách hàng",
      "TrangThai": "Đang hoạt động",
      "HangThanhVien": "Nhựa",
      "AvatarUrl" : "assets/account/images/474621319_122198072636131249_4305780536062375088_n.jpg"
    });

    registerUser(email, uid, name, "Email & Password");
  }
}