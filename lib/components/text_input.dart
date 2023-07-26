import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String textString;
  final String yourParam;
  final Function(String) onSelectParam;
  TextInput(
      {Key? key,
      required this.textString,
      required this.onSelectParam,
      required this.yourParam})
      : super(key: key);

  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Color(0xFF000000)),
      cursorColor: const Color(0xFF9b9b9b),
      controller: textController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: textString,
        hintStyle: const TextStyle(
            color: Color(0xFF9b9b9b),
            fontSize: 15,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
