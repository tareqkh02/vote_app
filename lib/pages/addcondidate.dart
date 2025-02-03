import 'package:flutter/material.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/servises/functions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; 
import 'package:vot_dapp/utils/constns.dart'; 

class AddCandidatePage extends StatefulWidget {
  final Web3Client ethClient;

  AddCandidatePage({required this.ethClient});

  @override
  _AddCandidatePageState createState() => _AddCandidatePageState();
}

class _AddCandidatePageState extends State<AddCandidatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  Future<void> _addCandidate() async {
    String name = _nameController.text;
    String photoUrl = _photoUrlController.text;

    if (name.isNotEmpty && photoUrl.isNotEmpty) {
      await addCandidate(name, photoUrl, widget.ethClient);
    } else {
      showToast(message: 'Please enter both name and photo URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Candidate'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Candidate Name'),
            ),
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(labelText: 'Photo URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCandidate,
              child: Text('Add Candidate'),
            ),
          ],
        ),
      ),
    );
  }
}
