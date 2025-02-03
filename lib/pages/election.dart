import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vot_dapp/classs/class.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/pages/electioninfo.dart';
import 'package:vot_dapp/pages/login.dart';
import 'package:vot_dapp/utils/constns.dart';
import 'package:web3dart/web3dart.dart';

class Election extends StatefulWidget {
  const Election({super.key});

  @override
  State<Election> createState() => _ElectionState();
}

class _ElectionState extends State<Election> {
  late Timer _timer;
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String electionName = Provider.of<ElectionProvider>(context).electionName;

    return Scaffold(
        appBar: AppBar(
            actions: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF14213d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  icon: const Icon(Iconsax.logout),
                  label: Text(
                    'Logout',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  )),
            ],
            title: Text(
              'Election',
              style: const TextStyle(fontSize: 25, color: Colors.white),
            )),
        body: Column(
          children: [
            Container(
                height: 150,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(255, 62, 165, 248),
                          Color.fromARGB(255, 1, 74, 134),
                        ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$electionName'),
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<DateTimeProvider>(
                      builder: (context, dateTimeProvider, child) {
                        Duration remainingTime =
                            dateTimeProvider.getRemainingTime();
                        return Text(
                          'Remaining Time: ${remainingTime.inHours}h ${remainingTime.inMinutes % 60}m ${remainingTime.inSeconds % 60}s',
                          style: TextStyle(fontSize: 15),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 120,
                      height: 30,
                      child: Consumer<DateTimeProvider>(
                        builder: (context, dateTimeProvider, child) {
                          Duration remainingTime =
                              dateTimeProvider.getRemainingTime();
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Color(0xFF14213d),
                            ),
                            onPressed: () {
                              if (remainingTime.inHours != 0 &&
                                  remainingTime.inMinutes != 0 &&
                                  remainingTime.inSeconds != 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Electioninfo(
                                      ethClient: ethClient!,
                                      electionName: controller.text,
                                    ),
                                  ),
                                );
                              } else {
                                showToast(message: 'the Vote is note acctive ');
                              }
                            },
                            child: Text(
                              'Go to vote',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
