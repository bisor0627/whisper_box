import 'package:flutter/material.dart';

class SearchSuggestion extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SearchSuggestion({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
    );
  }
}
