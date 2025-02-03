import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  bool _obscureText = true;
  final bool? isPasswordField;
  MyTextField(
      {super.key,
      required this.contoller,
      required this.isPasswordField,
      required this.label,
      required this.hinttext,
      required this.icon,
      this.obscureText = false,
      required this.validator});
  TextEditingController contoller = TextEditingController();
  String label;
  String hinttext;
  IconData icon;
  bool obscureText;
  Function validator;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: TextFormField(
        obscureText:
            widget.isPasswordField == true ? widget.obscureText : false,
        controller: widget.contoller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.purple,
          ),
          suffixIcon: new GestureDetector(
            onTap: () {
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
            },
            child: widget.isPasswordField == true
                ? Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: widget.obscureText == false
                        ? Colors.purple
                        : Colors.grey,
                  )
                : Text(""),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 205, 192, 192),
          labelText: widget.label,
          hintText: widget.hinttext,
          hintStyle: TextStyle(color: Color.fromARGB(255, 72, 61, 61)),
          labelStyle: const TextStyle(color: Colors.purple),
        ),
        validator: (val) => widget.validator(),
      ),
    );
  }
}
