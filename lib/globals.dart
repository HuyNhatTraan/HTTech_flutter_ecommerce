import 'package:flutter/material.dart';
import 'package:hehehehe/env.dart';

// Cái này để set page mà mình muốn đến ví dụ ở các file khác chỉ cần import globals.dart và yes nó lỏ
// và set thẳng currentPageIndex = [0 -> 3] sẽ tự động chuyển được đến trang đó
// và cú pháp để set cho nó là [ currentPageIndex.value = [0 -> 3] ]
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

// String baseUri = serverUri; // Server
String baseUri = localUri; // Local for testing purpose
