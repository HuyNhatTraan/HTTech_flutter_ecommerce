import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hehehehe/features/cart/screens/cart_screen.dart';
import 'package:hehehehe/features/cart/widgets/cart_button_widget.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';
import 'package:hehehehe/features/search/widgets/search_filter_bar.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _currentQuery; // giữ từ khóa hiện tại

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.searchQuery; // khởi tạo từ tham số truyền vào
  }

  String sort = '';

  @override
  Widget build(BuildContext context) {
    int _curentCartNum = 0;

    Color colorSortUnselect = const Color(0xFF9f9f9f); // Màu xám nhạt (cho cái chưa chọn)
    Color colorSortSelected = const Color(0xFF3980c3);

    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                _currentQuery = value; // cập nhật query => rebuild ProductCard
              });
            },
            initialValue: widget.searchQuery,
            style: const TextStyle(
              color: Color(0xFF3C81C6),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              isDense: true,
              prefixIcon: const Icon(Icons.search, size: 24, color: Color(0xFF3c81c6),),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [const CartButtonWidget()],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // const SearchFilterBar(),
          SliverAppBar(
            surfaceTintColor: Color(0xFFf5f5f5),
            automaticallyImplyLeading: false,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: Container(
              height: double.infinity,
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF9e9e9e)),
                  bottom: BorderSide(color: Color(0xFF9e9e9e)),
                ),
                color: Colors.white,
              ),
              //width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sort = '';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Liên quan',
                        style: TextStyle(
                          color: sort == '' ? colorSortSelected : colorSortUnselect,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey[800],
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sort = 'newest';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Mới nhất',
                        style: TextStyle(
                          color: sort == 'newest' ? colorSortSelected : colorSortUnselect,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey[800],
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sort = 'highest';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.north_outlined, color: sort == 'highest' ? colorSortSelected : colorSortUnselect, size: 16),
                          Text(
                            'Giá',
                            style: TextStyle(
                              color: sort == 'highest' ? colorSortSelected : colorSortUnselect,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProductCard(
                  key: ValueKey("$_currentQuery$sort"),
                  route: '/productSearch',
                  tenSanPham: _currentQuery,
                  sort: sort,
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text('---------- Có thể bạn sẽ thích ----------'),
                ),
                ProductCard(route: '/products'),
              ],
            ),
          )
        ],
      )
    );
  }
}
