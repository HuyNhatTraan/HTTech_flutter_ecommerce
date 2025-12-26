import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'features/cart/widgets/cart_button_widget.dart';
import 'globals.dart' as globals;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hehehehe/features/home/screens/home_screen.dart';
import 'package:hehehehe/features/category/screens/category_screen.dart';
import 'package:hehehehe/features/notification/screens/notification.dart';
import 'package:hehehehe/features/account/screens/account_main.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
import 'package:hehehehe/features/search/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Đăng ký handler cho background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Cấu hình local noti
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(),
        colorScheme: ColorScheme.light(),
      ),
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initialization();
    globals.currentPageIndex;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? message.data['title'];
      final rawBody = message.notification?.body ?? message.data['body'] ?? '';
      final body = rawBody.replaceFirst(RegExp(r'^(Thông báo:\s*)'), '');

      // Debug test xem có hiện hong ớ
      print('Title: $title');
      print('Body: $body');

      // Thêm vào Firestore với collection('notifications')
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'time': FieldValue.serverTimestamp(),
      });

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // ID kênh
              'Thông báo chung', // Tên kênh
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  void initialization() async {
    await Future.delayed(const Duration(milliseconds: 30));
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: globals.currentPageIndex,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            surfaceTintColor: Colors.transparent, // tắt cái overlay tím
            elevation: 4,
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Image.asset('assets/icon.png', height: 20),
            ),
            title: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: (value) {
                  print('Đã nhập $value');
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: true, // Giữ màn cũ hiển thị
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SearchScreen(searchQuery: value);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            final tween = Tween(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeInOutSine));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                    ),
                  );
                },
                style: TextStyle(
                  color: Color(0xFF3C81C6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  isDense: true,
                  prefixIcon: Icon(Icons.search, size: 24, color: Color(0xFF3c81c6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Color(0xFF3c81c6)
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF3c81c6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF3c81c6)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  // contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            actions: [const CartButtonWidget()],
          ),
          body: IndexedStack(
            index: value,
            children: [
              HomeScreen(),
              CategoryScreen(),
              ThongBao(),
              AccountMain(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: Color(0xFFc6e7ff),
            selectedIndex: value,
            onDestinationSelected: (index) =>
                globals.currentPageIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_outlined),
                selectedIcon: Icon(Icons.menu_open_outlined),
                label: 'Danh mục',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_none),
                selectedIcon: Icon(Icons.notifications),
                label: 'Thông báo',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: 'Tài khoản',
              ),
            ],
          ),
        );
      },
    );
  }
}
