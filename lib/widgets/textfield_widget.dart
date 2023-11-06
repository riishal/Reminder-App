import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  static FocusNode focusNode = FocusNode();

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.maxLine,
    required this.textController,
  });
  final String hintText;
  final int maxLine;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(9)),
        child: TextField(
          controller: textController,
          // focusNode: focusNode,
          // onTapOutside: (event) {
          //   focusNode.unfocus();
          // },
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText),
          maxLines: maxLine,
        ));
  }
}
