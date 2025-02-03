import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader(
      {super.key,
      required this.headLine,
      required this.description,
     });

  String headLine;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
        Text(
          headLine,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        Text(
          description,
          style: TextStyle(
              color: Color.fromARGB(255, 252, 250, 250).withOpacity(0.5),
              fontWeight: FontWeight.w300,
              height: 1.5,
              fontSize: 16),
        ),
      ],
    );
  }
}
