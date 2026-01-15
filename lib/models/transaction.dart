import 'dart:convert';

import 'package:dart_assincronismo/models/account.dart';

class Transaction {
  String transactionID;
  String senderAccountID;
  String receiverAccountID;
  DateTime date;
  double ammount;
  double taxes;

  Transaction({
    required this.transactionID,
    required this.senderAccountID,
    required this.receiverAccountID,
    required this.date,
    required this.ammount,
    required this.taxes,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionID: map["transactionID"],
      senderAccountID: map["senderAccountID"],
      receiverAccountID: map["receiverAccountID"],
      date: map["date"],
      ammount: map["ammount"],
      taxes: map["taxes"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "transactionID": transactionID,
      "senderAccountID": senderAccountID,
      "receiverAccountID": receiverAccountID,
      "date": date,
      "ammount": ammount,
      "taxes": taxes,
    };
  }

  factory Transaction.fromJson(String jsonData) {
    return Transaction.fromMap(json.decode(jsonData));
  }

  String toJson(Transaction transaction) {
    return json.encode(transaction.toMap());
  }

  Transaction copyWith({
    String? transactionID,
    String? senderAccountID,
    String? receiverAccountID,
    DateTime? date,
    double? ammount,
    double? taxes,
  }) {
    return Transaction(
      transactionID: transactionID ?? this.transactionID,
      senderAccountID: senderAccountID ?? this.senderAccountID,
      receiverAccountID: receiverAccountID ?? this.receiverAccountID,
      date: date ?? this.date,
      ammount: ammount ?? this.ammount,
      taxes: taxes ?? this.taxes,
    );
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return transactionID == other.transactionID &&
        senderAccountID == other.senderAccountID &&
        receiverAccountID == other.receiverAccountID &&
        date == other.date &&
        ammount == other.ammount &&
        taxes == other.taxes;
  }

  @override
  int get hashCode =>
      transactionID.hashCode ^
      senderAccountID.hashCode ^
      receiverAccountID.hashCode ^
      date.hashCode ^
      ammount.hashCode ^
      taxes.hashCode;

  @override
  String toString() {
    return "\n$date | Transação $transactionID | Conta $senderAccountID => Conta $receiverAccountID;\nValor: R\$$ammount, Taxa: $taxes\n";
  }
}
