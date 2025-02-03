import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vot_dapp/classs/class.dart';
import 'package:vot_dapp/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ElectionProvider()),
        ChangeNotifierProvider(create: (_) => DateTimeProvider()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.deepPurple))),
          appBarTheme: AppBarTheme(
            elevation: 0,
          )),
      home: Login(),

    );
  }
}
