import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guestbook/screen_takepicture.dart';

void main() async {
  runApp(const GuestBook());
}

class GuestBook extends StatelessWidget {
  const GuestBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const TakePicture(),
      ),
    );
  }
}
