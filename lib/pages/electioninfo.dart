import 'package:flutter/material.dart';
import 'package:vot_dapp/servises/functions.dart';
import 'package:web3dart/web3dart.dart';

class Electioninfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  const Electioninfo(
      {super.key, required this.ethClient, required this.electionName});

  @override
  State<Electioninfo> createState() => _ElectioninfoState();
}

class _ElectioninfoState extends State<Electioninfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController removCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.electionName,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getNumCandidates(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text(
                      'Total condidates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data![0].toString(),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          );
                        }),
                    Text(
                      'Total Votes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ]),
              Divider(),
              FutureBuilder<List>(
                future: getNumCandidates(widget.ethClient),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        for (int i = 0; i < snapshot.data![0].toInt(); i++)
                          FutureBuilder<List>(
                              future: candidateInfo(i, widget.ethClient),
                              builder: (context, candidatesnapshot) {
                                if (candidatesnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Container(
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF219ebc),
                                          Color(0xFF8ecae6),
                                        ])),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(candidatesnapshot
                                            .data![2]
                                            .toString()),
                                      ),
                                      title: Text(
                                        candidatesnapshot.data![0].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Votes: ' +
                                            candidatesnapshot.data![1]
                                                .toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 57, 12, 12)
                                                .withOpacity(0.5),
                                            fontWeight: FontWeight.w300,
                                            height: 1.5,
                                            fontSize: 15),
                                      ),
                                      trailing: Container(
                                        height: 35,
                                        width: 60,
                                        margin: EdgeInsets.all(0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Color(0xFF023047),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(

                                                  title: Text('Confirm Vote'),
                                                  content: Text(
                                                      'Are you sure you want to vote for this candidate?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        backgroundColor:
                                                            Color(0xFF023047),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          _isLoading = true;
                                                        });

                                                        vote(i,
                                                            widget.ethClient);
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 30),
                                                            () {
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        });
                                                      },
                                                      child: Text('Confirm'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: _isLoading
                                              ? CircularProgressIndicator()
                                              : Text('Vote'),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              })
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
