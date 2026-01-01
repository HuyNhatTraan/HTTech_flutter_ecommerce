import 'package:flutter/material.dart';
import 'package:hehehehe/env.dart';
import 'package:hehehehe/features/auth/services/auth_service.dart';

// Cái này để set page mà mình muốn đến ví dụ ở các file khác chỉ cần import globals.dart và yes nó lỏ
// và set thẳng currentPageIndex = [0 -> 3] sẽ tự động chuyển được đến trang đó
// và cú pháp để set cho nó là [ currentPageIndex.value = [0 -> 3] ]
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

AuthServices authServices = AuthServices();

String baseUri = ''; // Server

class Globals {
  static Future init() async {
    baseUri = await authServices.getIPServer();
    print('hehe: ' + baseUri);
  }
}

// String baseUri = localUri; // Local for testing purpose
// String baseUri = serverUri; // Server