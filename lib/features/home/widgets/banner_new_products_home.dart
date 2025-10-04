import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hehehehe/features/product/screens/product_info.dart';

class BannerSPMoi extends StatefulWidget {
  const BannerSPMoi({super.key});

  @override
  State<BannerSPMoi> createState() => _BannerSPMoiState();
}

class _BannerSPMoiState extends State<BannerSPMoi> {
  List list = [
    {
      'url':
          'https://www.phongcachxanh.vn/cdn/shop/files/pulsar-x2-CL-T1-PRX-2800px.jpg?v=1750911133&width=2000',
      'text': 'Chuột Pulsar X2 Crazylight PRX / T1 Edition',
      'MaSP': 'SP01',
    },
    {
      'url':
          'https://www.phongcachxanh.vn/cdn/shop/files/Yuki-aim-demon1-2800px.jpg?v=1750911127&width=2000',
      'text': 'Lót chuột Yuki Aim x Demon1 - Limited Edition',
      'MaSP': 'SP06',
    },
    {
      'url':
          'https://www.phongcachxanh.vn/cdn/shop/files/artisan-mousepad-2800px.jpg?v=1748923883&width=2000',
      'text': 'Mousepad Artisan Zero',
      'MaSP': 'SP01',
    },
    {
      'url':
          'https://www.phongcachxanh.vn/cdn/shop/files/Pulsar-X2F-2800px.jpg?v=1754626161&width=2000',
      'text': 'Pulsar X2F',
      'MaSP': 'SP09',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        animateToClosest: true,
      ),
      items: list.map((item) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(item['url']),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    item['text'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductInfo(maSanPham: item['MaSP']),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: Color(0xFFc6e7ff),
                        width: 2,
                      ), // màu + độ dày viền
                    ),
                  ),
                  child: Text('Xem ngay', style: TextStyle(color: Color(0xFF3c81c6), fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
