import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerSPMoi extends StatefulWidget {
  const BannerSPMoi({super.key});

  @override
  State<BannerSPMoi> createState() => _BannerSPMoiState();
}

class _BannerSPMoiState extends State<BannerSPMoi> {
  List<Map<String, String>> list = [
    {
      'url': 'https://www.phongcachxanh.vn/cdn/shop/files/pulsar-x2-CL-T1-PRX-2800px.jpg?v=1750911133&width=2000',
      'text': 'Chuột Pulsar X2 Crazylight PRX / T1 Edition',
    },
    {
      'url': 'https://www.phongcachxanh.vn/cdn/shop/files/Yuki-aim-demon1-2800px.jpg?v=1750911127&width=2000',
      'text': 'Lót chuột Yuki Aim x Demon1 - Limited Edition',
    },
    {
      'url': 'https://www.phongcachxanh.vn/cdn/shop/files/artisan-mousepad-2800px.jpg?v=1748923883&width=2000',
      'text': 'Mousepad Artisan Zero',
    },
    {
      'url': 'https://www.phongcachxanh.vn/cdn/shop/files/Pulsar-X2F-2800px.jpg?v=1754626161&width=2000',
      'text': 'Pulsar X2F',
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
                  image: NetworkImage(item['url']!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center (
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  item['text']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
            )
          );
        }).toList(),
    );
  }
}
