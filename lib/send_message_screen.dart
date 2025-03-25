import 'package:flutter/material.dart';
import 'dart:io'; // 파일 작업을 위한 import
import 'package:path/path.dart' as path; // 경로 작업을 위한 추가 import
import 'package:whisper_box/constans.dart';
import 'dart:math';

import 'package:whisper_box/user.dart'; // 랜덤 기능 추가

class SendMessageScreen extends StatelessWidget {
  final String? nickname;
  final String message;
  final bool isAnonymous; // 익명 여부 추가

  const SendMessageScreen({
    super.key,
    required this.nickname,
    required this.message,
    required this.isAnonymous, // 익명 여부 초기화
  });

  List<User> _getRandomUsers(int count) {
    final random = Random();
    final shuffled = List<User>.from(users)..shuffle(random);
    return shuffled.take(count).toList();
  }

  Future<void> _saveMessageToFile({List<User>? users}) async {
    try {
      // 현재 프로젝트 디렉토리 기준으로 message 폴더 생성
      final projectDir = Directory.current.path;
      final messageDir = Directory(path.join(projectDir, 'message'));

      // message 폴더 생성 (없으면 생성)
      if (!await messageDir.exists()) {
        await messageDir.create();
      }

      if (users != null) {
        // 여러 사용자에게 메시지 저장
        for (var user in users) {
          final userDir = Directory(path.join(messageDir.path, user.nickname));
          if (!await userDir.exists()) {
            await userDir.create();
          }

          final timestamp = DateTime.now().toIso8601String();
          final file = File(path.join(userDir.path, '$timestamp.txt'));
          await file.writeAsString(message);
          print('파일이 생성되었습니다: ${file.path}');
        }
      } else {
        // 단일 사용자에게 메시지 저장
        final userDir = Directory(path.join(messageDir.path, nickname));
        if (!await userDir.exists()) {
          await userDir.create();
        }

        final timestamp = DateTime.now().toIso8601String();
        final file = File(path.join(userDir.path, '$timestamp.txt'));
        await file.writeAsString(message);
        print('파일이 생성되었습니다: ${file.path}');
      }
    } catch (e) {
      print('파일 저장 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAnonymous) {
      final randomUsers = _getRandomUsers(5);
      _saveMessageToFile(users: randomUsers); // 랜덤 사용자에게 메시지 저장
      for (var user in randomUsers) {
        print('Sending message to ${user.nickname}: $message');
      }
    } else {
      _saveMessageToFile(); // 단일 사용자에게 메시지 저장
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nickname ?? '익명'),
      ),
      body: FutureBuilder(
        future: Future.value(), // 메시지 저장 후 UI 처리
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // 로딩 상태 표시
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '파일 저장 중 오류가 발생했습니다.',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 342,
                    height: 96,
                    child: Text(
                      '짝짝짝! 마음이 전해졌어요.\n행복을 전해줘서 고마워요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 29,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.popUntil(
                          context, (route) => route.isFirst); // HOME 화면으로 이동
                    },
                    child: Container(
                      width: 335,
                      height: 54,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 335,
                              height: 54,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF262626),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 140,
                            top: 16,
                            child: Text(
                              '처음으로',
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
