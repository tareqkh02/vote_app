import 'package:flutter/material.dart';

class CustomButotn extends StatelessWidget {
  CustomButotn({super.key, required this.title, required this.onPressed});

  String title;
  Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.purple,
          ),
          onPressed: () => onPressed(),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, color: Colors.white),
          )),
    );
  }
}
