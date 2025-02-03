import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/pages/login.dart';
import 'package:vot_dapp/pages/validation.dart';

import 'componants/custom_button.dart';
import 'componants/custom_header.dart';
import 'componants/custom_row.dart';
import 'componants/firebase/auth.dart';
import 'componants/text_field.dart';

// import '../services/api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final firestor = FirebaseFirestore.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationContrroller =
      TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationContrroller.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // color: Colors.red.withOpacity(0.1),
            image: DecorationImage(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7IBkCtYd6ulSfLfDL-aSF3rv6UfmWYxbSE823q36sPiQNVFFLatTFdGeUSnmJ4tUzlo&usqp=CAU'),
                fit: BoxFit.cover,
                opacity: 0.3)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomHeader(
                    headLine: 'Register',
                    description: 'Please Register to continue using our app',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextField(
                            isPasswordField: false,
                            contoller: _usernameController,
                            label: "Username",
                            hinttext: 'full name',
                            icon: Icons.person,
                            validator: () {
                              if (_usernameController.text.isEmpty) {
                                return 'Username Must Not Be Empty';
                              }
                            }),
                        MyTextField(
                            isPasswordField: false,
                            contoller: _emailController,
                            label: "Email",
                            hinttext: 'example@gmail.com',
                            icon: Icons.person,
                            validator: () {
                              if (_emailController.text.isEmpty) {
                                return 'Email Must Not Be Empty';
                              }
                              if (!isEmail(_emailController.text)) {
                                return 'Enter a valid Email';
                              }
                            }),
                        MyTextField(
                            isPasswordField: true,
                            contoller: _passwordController,
                            label: "Password",
                            hinttext: '*********',
                            icon: Icons.person,
                            validator: () {
                              if (_passwordController.text.isEmpty) {
                                return 'Password Must Not Be Empty';
                              }
                              if (_passwordController.text.length < 8) {
                                return 'Password Must Be Atleast 8 Characters';
                              }
                              if (_passwordController.text !=
                                  _passwordConfirmationContrroller.text) {
                                return 'Passwords Does Not Match';
                              }
                            }),
                        MyTextField(
                            isPasswordField: true,
                            contoller: _passwordConfirmationContrroller,
                            label: "Confirm Password",
                            hinttext: '*********',
                            icon: Icons.person,
                            validator: () {
                              if (_passwordConfirmationContrroller
                                  .text.isEmpty) {
                                return 'Password Must Not Be Empty';
                              }
                              if (_passwordConfirmationContrroller.text.length <
                                  8) {
                                return 'Password Must Be Atleast 8 Characters';
                              }
                              if (_passwordController.text !=
                                  _passwordConfirmationContrroller.text) {
                                return 'Passwords Does Not Match';
                              }
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButotn(
                    title: 'Sign Up',
                    onPressed: _signUp,
                  ),
                  CustomRow(
                      description: 'You Already Have An Account?',
                      textButton: 'Login',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      firestor.collection("user").add({
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "uid": user.uid
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Validation(),
          ));
    }
  }
}
