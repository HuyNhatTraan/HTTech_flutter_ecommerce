import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SettingVersionsApp extends StatefulWidget {
  const SettingVersionsApp({super.key});

  @override
  State<SettingVersionsApp> createState() => _SettingVersionsAppState();
}

class _SettingVersionsAppState extends State<SettingVersionsApp> {

  @override
  void initState() {
    super.initState();
    getNamePhone();
  }

  Future<void> getNamePhone() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("Check: ${androidInfo.toString()}");
    setState(() {
      phoneModel = androidInfo.model.toString();
      phoneAdrVer = androidInfo.version.release.toString();
    });
  }

  String phoneModel = "";
  String phoneAdrVer = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Giới thiệu', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsetsGeometry.all(20),
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Image(image: AssetImage('assets/icon.png'), width: 80,),
                    Text('HT Tech', style: TextStyle(color: Color(0xFF3c81c6), fontSize: 16, fontWeight: FontWeight.bold),),
                    Text('v1.0.0', style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(
                    msg: "Tính năng này đang được xây dựng",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFFd2f5fc),
                    textColor: Color(0xFF3c81c6),
                    fontSize: 16.0
                );
              },
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.all(15),
                    color: Colors.white,
                    child: Text('Xoá bộ nhớ'),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Fluttertoast.showToast(
                    msg: "Tính năng này đang được xây dựng",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFFd2f5fc),
                    textColor: Color(0xFF3c81c6),
                    fontSize: 16.0
                );
              },
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.all(15),
                    color: Colors.white,
                    child: Text('Cập nhật phiên bản'),
                  ),
                ],
              ),
            ),
            Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.all(15),
                    color: Colors.white,
                    child: Text('Thiết bị: $phoneModel'),
                  ),
                ],
              ),
            Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.all(15),
                    color: Colors.white,
                    child: Text('Phiên bản Android: $phoneAdrVer'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
