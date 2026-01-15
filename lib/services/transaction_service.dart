import 'dart:convert';

import 'package:dart_assincronismo/api_key.dart';
import 'package:dart_assincronismo/models/account.dart';
import 'package:dart_assincronismo/models/transaction.dart';
import 'package:dart_assincronismo/services/account_service.dart';
import 'package:dart_assincronismo/helpers/helper_taxes.dart';

import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final AccountService _accountService = AccountService();
  final String url =
      "https://api.github.com/gists/d3858aa4f950651416b0bb848baf7b2c";

  Future<void> makeTransaction({
    required String senderID,
    required String receiverID,
    required double ammount,
  }) async {
    List<Account> listAccount = await _accountService.getAll();
    if (listAccount.where((account) => account.id == senderID).isEmpty) return;
    if (listAccount.where((account) => account.id == receiverID).isEmpty) return;

    Account senderAcc = listAccount.firstWhere(
      (Account acc) => acc.id == senderID,
    );
    Account receiverAcc = listAccount.firstWhere(
      (Account acc) => acc.id == receiverID,
    );

    double taxes = calculateTaxesByAccount(senderAcc, ammount);
    if (senderAcc.balance < ammount + taxes) return;

    senderAcc.balance -= ammount + taxes;
    receiverAcc.balance += ammount;

    listAccount[listAccount.indexWhere((account) => account.id == senderID)] =
        senderAcc;
    listAccount[listAccount.indexWhere((account) => account.id == receiverID)] =
        receiverAcc;

    Uuid uuid = Uuid();
    Transaction transaction = Transaction(
      transactionID: uuid.v4(),
      senderAccountID: senderID,
      receiverAccountID: receiverID,
      date: DateTime.now(),
      ammount: ammount,
      taxes: taxes,
    );

    await _accountService.save(listAccount);
    await addTransaction(transaction);
  }

  Future<List<Transaction>> getAll() async {
    Response response = await get(Uri.parse(url));

    Map<String, dynamic> mapResponse = json.decode(response.body);

    List<dynamic> listDynamic = [];
    if (mapResponse["files"]["transaction.json"] != null) {
      listDynamic = json.decode(
        mapResponse["files"]["transaction.json"]["content"],
      );
    }

    List<Transaction> listTransactions = [];
    for (dynamic element in listDynamic) {
      Transaction transaction = Transaction.fromMap(
        element as Map<String, dynamic>,
      );
      listTransactions.add(transaction);
    }

    return listTransactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    List<Transaction> listTransactions = await getAll();
    listTransactions.add(transaction);
    await _save(listTransactions);
  }

  Future<void> _save(List<Transaction> listTransactions) async {
    List<Map<String, dynamic>> listMapTransactions = [];

    for (Transaction transaction in listTransactions) {
      listMapTransactions.add(transaction.toMap());
    }

    String content = json.encode(listMapTransactions);

    await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $GITHUB_API_KEY"},
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "transactions.json": {"content": content},
        },
      }),
    );
  }
}
