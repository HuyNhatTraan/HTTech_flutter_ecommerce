import 'package:flutter/material.dart';

class AccountInfoBanner extends StatefulWidget {
  final dynamic user;
  const AccountInfoBanner({super.key, this.user});

  @override
  State<AccountInfoBanner> createState() => _AccountInfoBannerState();
}

class _AccountInfoBannerState extends State<AccountInfoBanner> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên user
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Xin chào người anh em',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Email: ${widget.user.email}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 4,),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Hạng thành viên: Skibidi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
