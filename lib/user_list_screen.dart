import 'package:flutter/material.dart';
import 'package:whisper_box/constans.dart';
import 'user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _controllerSearch =
      TextEditingController(); // 검색 컨트롤러

  @override
  void dispose() {
    _controllerSearch.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((user) => user.nickname
            .toLowerCase()
            .contains(_controllerSearch.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _controllerSearch, // 컨트롤러 연결
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _ClearButton(controller: _controllerSearch),
            hintText: '편지를 보내고 싶은 상대를 검색하세요',
            border: const OutlineInputBorder(),
          ),
          onChanged: (query) {
            setState(() {
              // 검색어 업데이트
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return ListTile(
            title: Text(user.nickname),
            subtitle: user.name != null ? Text(user.name!) : null,
            onTap: () {
              Navigator.pop(context, user); // 선택한 user를 pop으로 전달
            },
          );
        },
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => controller.text.isNotEmpty
      ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.clear(); // 검색어 초기화
          },
        )
      : const SizedBox();
}
