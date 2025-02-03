import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vot_dapp/pages/componants/custom_button.dart';
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/pages/election.dart';
import 'package:vot_dapp/utils/constns.dart';
import 'package:web3dart/web3dart.dart';

class Validation extends StatefulWidget {
  const Validation({super.key});

  @override
  State<Validation> createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  String? voter_key;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('private key'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authorizeVoterController,
              decoration: InputDecoration(hintText: 'Enter your private key '),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 45,
              child: CustomButotn(
                title: 'Add Voter',
                onPressed: () {
                  String privateKey = authorizeVoterController.text;
                  if (privateKey.isNotEmpty) {
                    if (isValidPrivateKey(privateKey)) {
                      voter_private_key = privateKey;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) => /* Electioninfo(
                            ethClient: ethClient!,
                            electionName: controller.text,
                          ), */
                                    Election()),
                      );
                    } else {
                      showToast(message: 'Invalid private key');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isValidPrivateKey(String privateKey) {
  try {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;
    return isValidEthereumAddress(address);
  } catch (e) {
    return false;
  }
}
