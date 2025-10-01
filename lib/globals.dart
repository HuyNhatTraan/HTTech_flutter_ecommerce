import 'package:flutter/material.dart';

// Cái này đẻ set page mà mình muốn đến ví dụ ở các file khác chỉ cần import globals.dart
// và set thẳng currentPageIndex = [0 -> 3] sẽ tự động chuyển được đến trang đó
// và cú pháp để set cho nó là [ currentPageIndex.value = [0 -> 3] ]
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

// String baseUri = 'http://14.226.226.201:3000'; // Server
String baseUri = 'http://192.168.1.7:3000'; // Local for testing purpose
