import 'dart:async';
import 'dart:convert';

import 'package:dart_assincronismo/models/account.dart';
import 'package:http/http.dart';

import 'package:dart_assincronismo/api_key.dart';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url = "https://api.github.com/gists/d3858aa4f950651416b0bb848baf7b2c";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));

    _streamController.add("${DateTime.now()} | Requisição de leitura (async)");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamics = json.decode(
      mapResponse["files"]["accounts.json"]["content"],
    );

    List<Account> listAccounts = [];
    for (dynamic element in listDynamics) {
      Map<String, dynamic> mapAccount = element as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  void addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $GITHUB_API_KEY"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição de adição bem sucedida (${account.name}, ${response.statusCode})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição de adição falha (${account.name})",
      );
    }
  }

  Future<Account> getAccountByID(String id) async {
    List<Account> listAccount = await getAll();

    Account returnAccount = listAccount.firstWhere(
      (Account account) => account.id == id,
    );

    _streamController.add(
      "${DateTime.now()} | Requisição de conta e informações:\n$returnAccount",
    );
    return returnAccount;
  }

  void updateAccount(Account account) async {
    List<Account> listAccount = await getAll();

    bool isInList = false;
    for (int i = 0; i <= listAccount.length; i++) {
      if (listAccount[i].id == account.id) {
        isInList = true;
        listAccount[i] = account;
        break;
      }
    }

    if (!isInList) {
      _streamController.add(
        "${DateTime.now()} | Requisição inválida - id ${account.id} não existe",
      );
      return;
    }

    List<Map<String, dynamic>> listMapAccount = [];
    for (Account acc in listAccount) {
      listMapAccount.add(acc.toMap());
    }

    String content = json.encode(listMapAccount);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $GITHUB_API_KEY"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição de update bem sucedida (${account.id}, ${response.statusCode})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição de update falha (${account.id})",
      );
    }
  }

  void deleteAccount(String accountID) async {
    List<Account> listAccount = await getAll();

    bool isInList = false;
    for (int i = 0; i <= listAccount.length; i++) {
      if (listAccount[i].id == accountID) {
        isInList = true;
        listAccount.removeAt(i);
        break;
      }
    }

    if (!isInList) {
      _streamController.add(
        "${DateTime.now()} | Requisição inválida - id $accountID não existe",
      );
      return;
    }

    List<Map<String, dynamic>> listMapAccount = [];
    for (Account acc in listAccount) {
      listMapAccount.add(acc.toMap());
    }

    String content = json.encode(listMapAccount);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $GITHUB_API_KEY"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição de deleção bem sucedida ($accountID, ${response.statusCode})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição de deleção falha ($accountID)",
      );
    }
  }
}
