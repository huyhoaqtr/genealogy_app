import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class FileStorageContract {
  final String rpcUrl;
  final String contractAddress;
  final String privateKey;

  late Web3Client _client;
  late EthereumAddress _contractAddr;
  late DeployedContract _contract;

  FileStorageContract({
    required this.rpcUrl,
    required this.contractAddress,
    required this.privateKey,
  }) {
    _client = Web3Client(rpcUrl, Client());
    _contractAddr = EthereumAddress.fromHex(contractAddress);
  }

  Future<void> initializeContract() async {
    final String abiContent =
        await rootBundle.loadString('assets/json/abi.json');
    try {
      final parsedAbi = jsonDecode(abiContent); // Kiểm tra JSON hợp lệ
      final abiString = jsonEncode(parsedAbi); // Chuyển về chuỗi JSON hợp lệ
      _contract = DeployedContract(
        ContractAbi.fromJson(abiString, "FileStorage"),
        _contractAddr,
      );
    } catch (e) {
      throw Exception("Invalid ABI format: ${e.toString()}");
    }
  }

  Future<Map<String, String>> getFile(int id) async {
    final getFileFunction = _contract.function("getFile");

    final result = await _client.call(
      contract: _contract,
      function: getFileFunction,
      params: [BigInt.from(id)],
    );

    return {
      "tribeId": result[0] as String,
      "ownerId": result[1] as String,
      "ipfsAddress": result[2] as String,
    };
  }
}
