import 'dart:convert';
import 'dart:math';

import 'package:dart_exceptions/api_key.dart';
import 'package:dart_exceptions/exceptions/transaction_exceptions.dart';
import 'package:dart_exceptions/models/account.dart';
import 'package:dart_exceptions/models/transaction.dart';
import 'package:dart_exceptions/services/account_service.dart';
import 'package:dart_exceptions/helpers/helper_taxes.dart';

import 'package:http/http.dart';

class TransactionService {
  final AccountService _accountService = AccountService();
  final String url =
      "https://api.github.com/gists/d3858aa4f950651416b0bb848baf7b2c";

  makeTransaction({
    required String idSender,
    required String idReceiver,
    required double amount,
  }) async {
    List<Account> listAccount = await _accountService.getAll();
    if (listAccount.where((account) => account.id == idSender).isEmpty) {
      throw SenderDoNotExistException();
    }
    if (listAccount.where((account) => account.id == idReceiver).isEmpty) {
      throw ReceiverDoNotExistException();
    }

    Account senderAcc = listAccount.firstWhere(
      (Account acc) => acc.id == idSender,
    );

    if (listAccount.where((acc) => acc.id == idReceiver).isEmpty) {
      return null;
    }

    Account receiverAccount = listAccount.firstWhere(
      (acc) => acc.id == idReceiver,
    );

    double taxes = calculateTaxesByAccount(sender: senderAcc, amount: amount);
    if (senderAcc.balance < amount + taxes) {
      throw InsufficientFundsException(
        sender: senderAcc,
        amount: amount,
        taxes: taxes,
      );
    }

    if (senderAcc.balance < amount + taxes) {
      return null;
    }

    senderAcc.balance -= (amount + taxes);
    receiverAccount.balance += amount;

    listAccount[listAccount.indexWhere(
      (acc) => acc.id == senderAcc.id,
    )] = senderAcc;

    listAccount[listAccount.indexWhere(
      (acc) => acc.id == receiverAccount.id,
    )] = receiverAccount;

    Transaction transaction = Transaction(
      id: (Random().nextInt(89999) + 10000).toString(),
      senderAccountId: senderAcc.id,
      receiverAccountId: receiverAccount.id,
      date: DateTime.now(),
      amount: amount,
      taxes: taxes,
    );

    await _accountService.save(listAccount);
    await addTransaction(transaction);
  }

  Future<List<Transaction>> getAll() async {
    Response response = await get(Uri.parse(url));

    // List<dynamic> listDynamic = json.decode(response.body);
    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic = [];
    if (mapResponse["files"]["transactions.json"] != null) {
      listDynamic = json.decode(
        mapResponse["files"]["transactions.json"]["content"],
      );
    }

    List<Transaction> listTransactions = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapTrans = dyn as Map<String, dynamic>;
      Transaction transaction = Transaction.fromMap(mapTrans);
      listTransactions.add(transaction);
    }

    return listTransactions;
  }

  addTransaction(Transaction trans) async {
    List<Transaction> listTransactions = await getAll();
    listTransactions.add(trans);
    save(listTransactions);
  }

  save(List<Transaction> listTransactions) async {
    List<Map<String, dynamic>> listMaps = [];

    for (Transaction trans in listTransactions) {
      listMaps.add(trans.toMap());
    }

    String content = json.encode(listMaps);

    await post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $GITHUB_API_KEY",
      },
      body: json.encode({
        "description": "accounts.json",
        "public": true,
        "files": {
          "transactions.json": {"content": content}
        }
      }),
    );
  }
}
