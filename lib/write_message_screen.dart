import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whisper_box/constans.dart';
import 'package:whisper_box/start_screen.dart';
import 'package:whisper_box/user.dart';
import 'user_list_screen.dart';
import 'send_message_screen.dart';
import 'dart:math'; // 랜덤 기능 추가

class WriteMessageScreen extends ConsumerStatefulWidget {
  const WriteMessageScreen({super.key});

  @override
  ConsumerState<WriteMessageScreen> createState() => _WriteMessageScreenState();
}

class _WriteMessageScreenState extends ConsumerState<WriteMessageScreen> {
  late final TextEditingController _messageController;
  int _selectedChipIndex = 0; // 선택된 Chip의 인덱스
  User? _selectedUser; // 선택된 사용자
  bool _isAnonymous = false; // 익명 여부

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    if (_isAnonymous) {
      return _messageController.text.isNotEmpty;
    }
    return _selectedUser != null && _messageController.text.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const AppTitle(),
            SizedBox(
              width: 335,
              child: Text(
                '따스한 말 한마디가 큰 파장이 돼요',
                style: TextStyle(
                  color: const Color(0xFF6F6F6F),
                  fontSize: 15,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.47,
                ),
              ),
            ),
            Text(
              '받는 사람 선택하기',
              style: TextStyle(
                color: const Color(0xFF212124),
                fontSize: 15.86,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.40,
              ),
            ),
            if (!_isAnonymous)
              ElevatedButton(
                onPressed: () async {
                  final selectedUser = await Navigator.push<User>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserListScreen(),
                    ),
                  );
                  if (selectedUser != null) {
                    setState(() {
                      _selectedUser = selectedUser;
                    });
                  }
                },
                child: Text(
                  _selectedUser != null
                      ? _selectedUser!.nickname
                      : '누구에게 마음을 전해볼까요?',
                  style: TextStyle(
                    color: const Color(0xFF4D5159) /* Gray_700 */,
                    fontSize: 13.99,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            Row(
              children: [
                Text(
                  '쪽지 작성하기',
                  style: TextStyle(
                    color: const Color(0xFF212124) /* Gray_900 */,
                    fontSize: 15.86,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      _isAnonymous ? '익명 해제' : '익명에게 보내기',
                      style: TextStyle(
                        color: const Color(0xFF878B93) /* Gray_600 */,
                        fontSize: 13.06,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                        letterSpacing: 0.26,
                      ),
                    ),
                    Switch(
                      value: _isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          _isAnonymous = value;
                          if (_isAnonymous) {
                            _selectedUser = null; // 받는 사람 초기화
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 42),
            TextFormField(
              controller: _messageController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: templates[_selectedChipIndex]
                    .contents, // templates의 contents 값 사용
              ),
              onChanged: (value) {
                setState(() {
                  // 메시지 변경 시 상태 업데이트
                });
              },
              onFieldSubmitted: (value) {
                _messageController.clear();
              },
            ),
            Wrap(
              spacing: 8.0,
              children: List.generate(templates.length, (index) {
                return ChoiceChip(
                  label: Text(templates[index].label),
                  selected: _selectedChipIndex == index,
                  onSelected: (selected) {
                    setState(() {
                      _selectedChipIndex =
                          selected ? index : _selectedChipIndex;
                    });
                  },
                  showCheckmark: false, // 체크 아이콘 비활성화
                  labelStyle: TextStyle(
                    color: _selectedChipIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }),
            ),
            SizedBox(
              width: 335,
              child: Text(
                '익명에게 보내기는 랜덤 상대에게 쪽지를 보내는 기능입니다.\n추천 주제에 대한 쪽지를 보내주세요! \n익명의 상대로부터 비밀 답장을 받을 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6F6F6F),
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.69,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMessageScreen(
                            nickname:
                                _isAnonymous ? null : _selectedUser!.nickname,
                            message: _messageController.text,
                            isAnonymous: _isAnonymous, // 익명 여부 전달
                          ),
                        ),
                      );
                    }
                  : null, // 조건 충족하지 않으면 비활성화
              child: Text(
                '마음 전하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isFormValid()
                      ? Colors.white
                      : const Color(0xFFA8A8A8), // 비활성화 시 색상 변경
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
    );
  }
}

/// 상단 "todos" 타이틀 위젯
class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      child: Text(
        '마음 전하기',
        style: TextStyle(
          color: const Color(0xFF262626),
          fontSize: 24,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 1.33,
        ),
      ),
    );
  }
}
