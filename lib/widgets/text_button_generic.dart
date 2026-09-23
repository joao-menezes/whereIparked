import 'package:flutter/material.dart';

class TextButtonGeneric extends StatelessWidget {
  const TextButtonGeneric(this.onPressed, this.text, {super.key});

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}
