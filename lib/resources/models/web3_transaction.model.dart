class Web3Transaction {
  String? txHash;

  Web3Transaction({this.txHash});

  Web3Transaction.fromJson(Map<String, dynamic> json) {
    txHash = json['txHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txHash'] = this.txHash;
    return data;
  }
}
