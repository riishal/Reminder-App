import 'package:flutter/material.dart';

class AlertMessage {
  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  static void showComplete({
    required String title,
    String? content,
    required VoidCallback onTap,
    required VoidCallback onCancel,
    Widget? widget,
    context,
  }) {
    AlertDialog alertDialog = AlertDialog(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Row(
        children: [
          Text(
            title,
          ),
          SizedBox(
            width: 7,
          ),
          widget!
        ],
      ),
      content: Text(
        content!,
      ),
      actions: [
        TextButton(
            onPressed: () => onCancel(),
            child: Text(
              "No",
            )),
        TextButton(
            onPressed: () => onTap(),
            child: Text(
              "Yes",
            )),
      ],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }
}
