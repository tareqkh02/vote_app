import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:validators/validators.dart';
import 'package:vot_dapp/pages/adminpannel.dart';
import 'package:vot_dapp/pages/componants/firebase/auth.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/pages/signup.dart';
import 'package:vot_dapp/pages/validation.dart';
import 'package:vot_dapp/utils/constns.dart';
import 'package:web3dart/web3dart.dart';

import 'componants/custom_button.dart';
import 'componants/custom_header.dart';
import 'componants/custom_row.dart';
import 'componants/text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Web3Client? ethClient;
  Client? httpClient;
  bool _isSigning = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _AdminemailController = TextEditingController();
  TextEditingController _AdminpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
                    headLine: 'Log In Now',
                    description: 'Please login to continue using our app',
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
                          contoller: _emailController,
                          label: "Email",
                          hinttext: "example@gmail.com",
                          icon: Icons.person,
                          validator: () {
                            if (_emailController.text.isEmpty) {
                              return 'Email Must Not Be Empty';
                            }
                            if (!isEmail(_emailController.text)) {
                              return 'Enter a valid Email';
                            }
                          },
                        ),
                        MyTextField(
                          isPasswordField: true,
                          contoller: _passwordController,
                          label: "Password",
                          hinttext: "*********",
                          icon: Icons.lock,
                          obscureText: false,
                          validator: () {
                            if (_passwordController.text.isEmpty) {
                              return 'Password Must Not Be Empty';
                            }
                            if (_passwordController.text.length < 6) {
                              return 'Password Must Be Atleast 8 Characters';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  CustomButotn(
                    title: 'Log In',
                    onPressed: () {
                      _signIn();
                    },
                  ),
                  CustomRow(
                    description: 'You Do Not Have An Account?',
                    textButton: 'Sign Up',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    String adminEmail = _emailController.text;
    String adminPassword = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    User? adminUser = await _auth.signInAsAdmin(adminEmail, adminPassword);

    setState(() {
      _isSigning = false;
    });
    if (adminUser != null) {
      showToast(message: 'Admin signed in successfully');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Adminpanel(ethClient: ethClient!)));
    } else if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Validation()));
    } else {
      showToast(message: "some error occured");
    }
  }
}
