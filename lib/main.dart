import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hehehehe/features/home/screens/homeScreen.dart';
import 'package:hehehehe/features/category/screens/categoryScreen.dart';
import 'package:hehehehe/features/notification/screens/notification.dart';
import 'package:hehehehe/features/account/screens/accountMain.dart';
import 'package:hehehehe/features/cart/screens/cartScreen.dart';
import 'package:hehehehe/features/search/search_screen.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  }

  void initialization() async {
    await Future.delayed(const Duration(milliseconds: 30));
    // print('ready in 0.5s...');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>( // phải return
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
              child: Image.asset('assets/icon.png', width: 20, height: 20),
            ),
            title: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: (value){
                  print('Đã nhập' + value);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: true, // Giữ màn cũ hiển thị
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SearchScreen(searchQuery: value);
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOutSine));

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
                  hintText: 'Tìm kiếm sản phẩm...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  isDense: true,
                  prefixIcon: Icon(Icons.search, size: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF3c81c6),
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                    print("Đi tới giỏ hàng");
                  },
                ),
              ),
            ],
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
            onDestinationSelected: (index) => globals.currentPageIndex.value = index,
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
