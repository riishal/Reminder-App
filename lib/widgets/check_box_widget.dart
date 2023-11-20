import 'package:flutter/material.dart';

class OtherTaskField extends StatelessWidget {
  const OtherTaskField({
    super.key,
    required this.text,
    required this.value,
    this.onChanged,
  });
  final String text;
  final bool value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(width: 1, color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Checkbox(activeColor: Colors.blue, value: value, onChanged: onChanged)
        ],
      ),
    );
  }
}
