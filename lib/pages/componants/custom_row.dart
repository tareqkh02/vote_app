import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  CustomRow(
      {super.key,
      required this.description,
      required this.textButton,
      required this.onPressed});

  String description;
  String textButton;
  Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          description,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        TextButton(
          onPressed: () => onPressed(),
          child: Text(
            textButton,
            style: const TextStyle(
                color: Colors.purple, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
