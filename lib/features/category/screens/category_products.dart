import 'package:flutter/material.dart';
import 'package:hehehehe/globals.dart';
import 'package:hehehehe/features/product/widgets/product_card.dart';

class DanhMucSanPhamProducts extends StatefulWidget {
  final String maDanhMuc;
  final String tenDanhMuc;
  final String bannerDanhMuc;

  const DanhMucSanPhamProducts({
    super.key,
    required this.maDanhMuc,
    required this.tenDanhMuc,
    required this.bannerDanhMuc,
  });

  @override
  State<DanhMucSanPhamProducts> createState() => _DanhMucSanPhamProductsState();
}

class _DanhMucSanPhamProductsState extends State<DanhMucSanPhamProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent, // tắt cái overlay tím
        elevation: 4,
        title: Text(
          widget.tenDanhMuc,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(baseUri + '/' + widget.bannerDanhMuc),
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Danh mục ' + widget.tenDanhMuc,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ProductCard(route: '/categoryProduct', maDanhMuc: widget.maDanhMuc),
            // Padding(
            //   padding: EdgeInsetsGeometry.all(10),
            //   child: _isLoading
            //       ? const Center(child: CircularProgressIndicator())
            //       : _products
            //             .isEmpty // Sau khi tải xong, nếu không có sản phẩm thì hiển thị thông báo
            //       ? Center(
            //           child: Padding(
            //             padding: EdgeInsets.all(20.0),
            //             child: Text(
            //               "Không có sản phẩm nào thuộc danh mục này.",
            //               style: TextStyle(fontSize: 16, color: Colors.grey),
            //             ),
            //           ),
            //         )
            //       : GridView.builder(
            //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount: 2, // số cột
            //             mainAxisExtent: 330,
            //           ),
            //           shrinkWrap: true,
            //           physics: const NeverScrollableScrollPhysics(),
            //           itemCount: _products.length,
            //           itemBuilder: (context, index) {
            //             final product = _products[index];
            //             return GestureDetector(
            //               onTap: () {
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ProductInfo(MaSanPham: product["MaSanPham"])));
            //                 print('Đã ấn ' + product["TenSanPham"]);
            //               },
            //               child: Container(
            //                 padding: EdgeInsets.all(5),
            //                 child: Row(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Expanded(
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(10),
            //                           border: Border.all(
            //                             color: Colors.grey,
            //                             width: 1,
            //                           ),
            //                           color: Colors.white,
            //                         ),
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             // Ảnh sản phẩm
            //                             Container(
            //                               height: 200,
            //                               width: double.infinity,
            //                               decoration: BoxDecoration(
            //                                 borderRadius:
            //                                     const BorderRadius.only(
            //                                       topLeft: Radius.circular(10),
            //                                       topRight: Radius.circular(10),
            //                                     ),
            //                                 image: DecorationImage(
            //                                   image: NetworkImage(
            //                                     baseUri + '/' + product["HinhAnhDaiDienSP"],
            //                                   ),
            //                                   fit: BoxFit.cover,
            //                                 ),
            //                               ),
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.all(8.0),
            //                               child: Column(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.start,
            //                                 children: [
            //                                   Text(
            //                                     product["TenSanPham"],
            //                                     maxLines: 2,
            //                                     overflow: TextOverflow.ellipsis,
            //                                     style: const TextStyle(
            //                                       fontSize: 14,
            //                                       fontWeight: FontWeight.w600,
            //                                     ),
            //                                   ),
            //                                   const SizedBox(height: 6),
            //                                   // Giá
            //                                   Row(
            //                                     children: [
            //                                       Text(
            //                                         product["GiaSP"].toString().toVND(unit: 'đ'),
            //                                         style: TextStyle(
            //                                           fontSize: 16,
            //                                           fontWeight:
            //                                               FontWeight.bold,
            //                                           color: Colors.blue,
            //                                         ),
            //                                       ),
            //                                       SizedBox(width: 6),
            //                                     ],
            //                                   ),
            //                                   const SizedBox(height: 8),
            //
            //                                   // Rating + đã bán
            //                                   Row(
            //                                     children: const [
            //                                       Icon(
            //                                         Icons.star,
            //                                         color: Colors.amber,
            //                                         size: 16,
            //                                       ),
            //                                       SizedBox(width: 4),
            //                                       Text("4.9"),
            //                                       SizedBox(width: 8),
            //                                       Text(
            //                                         "Đã bán 500 cái",
            //                                         style: TextStyle(
            //                                           fontSize: 12,
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             )..fadeInUp(from: 100, duration: Duration(milliseconds: 400));
            //           },
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
