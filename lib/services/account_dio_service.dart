import 'dart:convert';

import 'package:dart_assincronismo/api_key.dart';
import 'package:dart_assincronismo/models/account.dart';
import 'package:dio/dio.dart';

class AccountDioService {
  final Dio dio = Dio(
    BaseOptions(headers: {'Authorization': 'Bearer $GITHUB_API_KEY'}),
  );
  String url = "https://api.github.com.br/gists/d3858aa4f950651416b0bb848baf7b2c";

  Future<List<Account>> getAll() async {
    Response response;
    try {
      response = await dio.get(url);
    } on DioException catch (e) {
      print("Erro na conexão com o servidor, URL inválido.");
      print(e.message);
      return [];
    }

    Map<String, dynamic> mapResponse = json.decode(response.toString());
    List<dynamic> listDynamic = json.decode(
      mapResponse["files"]["accounts.json"]["content"],
    );

    List<Account> listAccounts = [];
    for (dynamic element in listDynamic) {
      Account account = Account.fromMap(element);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  Future<void> addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await dio.patch(
      url,
      data: {
        "files": {
          "accounts.json": {"content": content},
        },
      },
    );
  }
}
