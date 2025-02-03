import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:vot_dapp/classs/class.dart';
import 'package:vot_dapp/pages/addcondidate.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/servises/functions.dart';
import 'package:vot_dapp/utils/constns.dart';
import 'package:web3dart/web3dart.dart';

class Adminpanel extends StatefulWidget {
  final Web3Client ethClient;

  const Adminpanel({super.key, required this.ethClient});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController removCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  TextEditingController ElectionnameController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    ElectionnameController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(BuildContext context) async {
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        dateTimeProvider.setStartDateTime(date, time);
      }
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    DateTimeProvider dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        dateTimeProvider.setEndDateTime(date, time);
      }
    }
  }

  Future<void> _startVote(BuildContext context) async {
    final dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    final startDateTime = dateTimeProvider.startDateTime;
    final endDateTime = dateTimeProvider.endDateTime;

    if (startDateTime != null && endDateTime != null) {
      try {
        await startVote(
          startDateTime.year,
          startDateTime.month,
          startDateTime.day,
          startDateTime.hour,
          startDateTime.minute,
          endDateTime.year,
          endDateTime.month,
          endDateTime.day,
          endDateTime.hour,
          endDateTime.minute,
          widget.ethClient,
        );
        showToast(message: 'Voting period set successfully');
      } catch (e) {
        showToast(message: 'Error starting vote: $e');
      }
    } else {
      showToast(message: 'Please select valid start and end dates/times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
       
        ),
        body: Container(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                          Text('Total condidates')
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
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                          Text('Total Votes')
                        ],
                      ),
                    ]),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => _pickStartDate(context),
                  child: Text("Pick Start Date and Time"),
                ),
                ElevatedButton(
                  onPressed: () => _pickEndDate(context),
                  child: Text("Pick End Date and Time"),
                ),
                ElevatedButton(
                  onPressed: () => _startVote(context),
                  child: Text("Start Vote"),
                ),
                ElevatedButton(
                  onPressed: () {
               
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCandidatePage(
                                  ethClient: widget.ethClient,
                                )));
                  },
                  child: Text('Add Candidate'),
                ),
                ElevatedButton(
                    onPressed: () {
                      resetVote(widget.ethClient);
                    },
                    child: Text('rest vote ')),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ElectionnameController,
                        decoration:
                            InputDecoration(hintText: 'Enter election name'),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (ElectionnameController.text.length > 0) {
                            Provider.of<ElectionProvider>(context,
                                    listen: false)
                                .setElectionName(ElectionnameController.text);
                            startElection(
                                ElectionnameController.text, widget.ethClient);
                          }
                        },
                        child: Text('Start election'))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: removCandidateController,
                        decoration:
                            InputDecoration(hintText: 'Enter Candidate index'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });

                        int indexToRemove =
                            int.tryParse(removCandidateController.text) ?? -1;
                        if (indexToRemove >= 0) {
                          removeCandidate(indexToRemove, widget.ethClient)
                              .then((_) {
                            Future.delayed(Duration(seconds: 30), () {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          });
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Remove Candidate'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: authorizeVoterController,
                        decoration:
                            InputDecoration(hintText: 'Enter Voter address'),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          if (authorizeVoterController.text.length > 0) {
                            authorizeVoter(authorizeVoterController.text,
                                widget.ethClient);
                          }
                          Future.delayed(Duration(seconds: 30), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                        child: Text('Add Voter'))
                  ],
                ),
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
                                    return ListTile(
                                      leading: Image.network(candidatesnapshot
                                          .data![2]
                                          .toString()),
                                      title: Text('Name: ' +
                                          candidatesnapshot.data![0]
                                              .toString()),
                                      subtitle: Text('Votes: ' +
                                          candidatesnapshot.data![1]
                                              .toString()),
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
        ));
  }
}
