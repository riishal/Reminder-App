import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({super.key, required this.day, required this.color});
  final String day;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        day,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 15),
      ),
    );
  }
}
