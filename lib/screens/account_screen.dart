import 'dart:io';

import 'package:dart_assincronismo/models/account.dart';
import 'package:dart_assincronismo/services/account_dio_service.dart';
import 'package:dart_assincronismo/services/account_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();
  final AccountDioService dioService = AccountDioService();

  void initializeStream() {
    _accountService.streamInfos.listen((event) => print(event));
  }

  void runChatBot() async {
    print("Bom dia. Meu nome é Chris!");
    print("Prazer em tê-lo conosco!\n");

    bool isRunning = true;
    while (isRunning) {
      print("Digite o número desejado.");
      print("1 - Ver todas as contas");
      print("2 - Adicionar nova conta");
      print("3 - Sair\n");

      String? input = stdin.readLineSync();

      if (input != null) {
        switch (input) {
          case "1":
            {
              await _getAllAccounts();
              break;
            }
          case "2":
            {
              await _addExampleAccount();
              break;
            }
          case "3":
            {
              isRunning = false;
              print("Até logo!");
              break;
            }
          default:
            {
              print("Comando inválido. Tente novamente.");
              break;
            }
        }
      }
    }
  }

  Future<void> _getAllAccounts() async {
    // try {
    //   List<Account> listAccounts = await _accountService.getAll();
    //   print(listAccounts);
    // } on ClientException catch (clientException) {
    //   print("Não foi possível alcançar o servidor, tente novamente.");
    //   print(clientException.message);
    //   print(clientException.uri);
    // } on Exception {
    //   print("Recuperação dos dados falhou, tente novamente.");
    // } finally {
    //   print("${DateTime.now()} | Ocorreu uma tentativa de consulta");
    // }
    List<Account> listAcc = await dioService.getAll();
    print(listAcc);
  }

  Future<void> _addExampleAccount() async {
    print("Digite o nome: ");
    String nameStr = stdin.readLineSync()!;
    print("Digite o saldo (R\$):");
    double balance = double.parse(stdin.readLineSync()!);

    String name = nameStr.split(' ')[0];
    String lastName = nameStr.split(' ')[1];

    Uuid uuid = Uuid();
    Account example = Account(
      id: uuid.v4(),
      name: name,
      lastName: lastName,
      balance: balance,
    );

    // _accountService.addAccount(example);
    await dioService.addAccount(example);
  }
}
