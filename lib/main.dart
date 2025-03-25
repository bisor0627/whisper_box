import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper_box/constans.dart';
import 'package:whisper_box/start_screen.dart';
import 'package:whisper_box/user.dart';
import 'user_list_screen.dart';
import 'send_message_screen.dart'; // SendMessageScreen import 추가

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // 기준 디바이스 (iPhone X 등)
      minTextAdapt: true,
      builder: (_, __) => const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
    );
  }
}
