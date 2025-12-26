import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                Fluttertoast.showToast(
                  msg: "Đã ấn Liên quan",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFFc6e7ff),
                  textColor: Color(0xFF3c81c6),
                  fontSize: 16.0,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Liên quan',
                  style: TextStyle(
                    color: Colors.grey[800],
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
                Fluttertoast.showToast(
                  msg: "Đã ấn mới nhất",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFFc6e7ff),
                  textColor: Color(0xFF3c81c6),
                  fontSize: 16.0,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Mới nhất',
                  style: TextStyle(
                    color: Colors.grey,
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
                Fluttertoast.showToast(
                  msg: "Đã ấn giá",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFFc6e7ff),
                  textColor: Color(0xFF3c81c6),
                  fontSize: 16.0,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.north_outlined, color: Colors.grey, size: 16),
                    Text(
                      'Giá',
                      style: TextStyle(
                        color: Colors.grey,
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
    );
  }
}
