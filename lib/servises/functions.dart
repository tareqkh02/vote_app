import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; 
import 'package:vot_dapp/pages/componants/firebase/toast.dart';
import 'package:vot_dapp/utils/constns.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAdress = contractadress;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAdress));

  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privatekey) async {
  EthPrivateKey credentils = EthPrivateKey.fromHex(privatekey);
  DeployedContract contract = await loadContract();

  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentils,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, owner_private_key);
  showToast(message: 'Election started successfully');
  return response;
}

Future<String> addCandidate(String name, String photoUrl, Web3Client ethClient) async {
  var response = await callFunction('addCandidate', [name, photoUrl], ethClient, owner_private_key);
  showToast(message: 'Candidate added successfully');
  return response;
}

Future<String> setCandidatePhoto(int index, String photoUrl, Web3Client ethClient) async {
  var response = await callFunction('setCandidatePhoto', [BigInt.from(index), photoUrl], ethClient, owner_private_key);
  showToast(message: 'Candidate photo set successfully');
  return response;
}

Future<String> removeCandidate(int index, Web3Client ethClient) async {
  var response = await callFunction(
      'removeCandidate', [BigInt.from(index)], ethClient, owner_private_key);
       showToast(message: 'Candidate removed successfully');
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  showToast(message: 'Voter Authorized successfully');
  return response;
}

Future<List<dynamic>> getNumCandidates(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List<dynamic>> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List<dynamic>> candidateInfo(int index, Web3Client ethClient) async {

  List<dynamic> result = await ask('candidateInfo', [BigInt.from(index)], ethClient);
  

  return result;
}


Future<String> vote(int candidateIndex, Web3Client ethClient) async {
 try {
    var response = await callFunction(
        'vote', [BigInt.from(candidateIndex)], ethClient, voter_private_key);
    showToast(message: 'Vote counted successfully');
    return response;
  } catch (e) {
    showToast(message: 'Failed to count vote: ${e.toString()}');
    return 'Failed';
  }
}

Future<String> resetVote(Web3Client ethClient) async {
  var response =
      await callFunction('resetVote', [], ethClient, owner_private_key);
  showToast(message: 'Votes have been reset successfully');
  return response;
}


Future<String> startVote(
    int startYear,
    int startMonth,
    int startDay,
    int startHour,
    int startMinute,
    int endYear,
    int endMonth,
    int endDay,
    int endHour,
    int endMinute,
    Web3Client ethClient) async {
  var response = await callFunction(
      'startVote',
      [
        BigInt.from(startYear),
        BigInt.from(startMonth),
        BigInt.from(startDay),
        BigInt.from(startHour),
        BigInt.from(startMinute),
        BigInt.from(endYear),
        BigInt.from(endMonth),
        BigInt.from(endDay),
        BigInt.from(endHour),
        BigInt.from(endMinute)
      ],
      ethClient,
      owner_private_key);
  showToast(message: 'Voting period set successfully');
  return response;
}
