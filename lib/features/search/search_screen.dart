import 'package:flutter/material.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              prefixIcon: const Icon(Icons.search, size: 24),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFF3c81c6),
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Kết quả: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "' $_currentQuery' ",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3c81c6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ProductCard(
              key: ValueKey(_currentQuery), // ép rebuild khi query đổi
              route: '/products',
              tenSanPham: _currentQuery,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text('---------- Có thể bạn sẽ thích ----------'),
            ),
            ProductCard(route: '/products'),
          ],
        ),
      ),
    );
  }
}
