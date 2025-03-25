import 'package:flutter/material.dart';
import 'package:whisper_box/write_message_screen.dart';
import 'main.dart'; // HomePage import 추가

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 328,
              height: 328,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/image/38866.png'),
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 342,
              height: 96,
              child: Text(
                '작은 응원 메시지를 보내요.\n행복이 전염될거예요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 29,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WriteMessageScreen()),
                );
              },
              child: Container(
                width: 335,
                height: 54,
                decoration: ShapeDecoration(
                  color: const Color(0xFF262626),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Center(
                  child: Text(
                    '마음 전하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
