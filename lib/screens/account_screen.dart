import 'dart:io';

import 'package:dart_exceptions/helpers/helper_taxes.dart';
import 'package:dart_exceptions/models/transaction.dart';
import 'package:dart_exceptions/services/account_service.dart';
import 'package:dart_exceptions/services/transaction_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import '../models/account.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();

  void initializeStream() {
    _accountService.streamInfos.listen(
      (event) {
        print(event);
      },
    );
  }

  Future<void> runChatBot() async {
    print("Bom dia! Eu sou o Lewis, assistente do Banco d'Ouro!");
    print("Que bom te ter aqui com a gente.\n");

    bool isRunning = true;
    while (isRunning) {
      print("Como eu posso te ajudar? (digite o número desejado)");
      print("1 - 👀 Ver todas sua contas.");
      print("2 - ➕ Adicionar nova conta.");
      print("3 - ➕ Fazer tranzação.");
      print("4 - Sair\n");

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
              await _makeNewTransaction();
              break;
            }
          case "4":
            {
              isRunning = false;
              print("Te vejo na próxima. 👋");
              break;
            }
          default:
            {
              print("Não entendi. Tente novamente.");
            }
        }
      }
    }
  }

  _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print(listAccounts);
    } on ClientException catch (clientException) {
      print("Não foi possível alcançar o servidor.");
      print("Tente novamente mais tarde.");
      print(clientException.message);
      print(clientException.uri);
    } on Exception {
      print("Não consegui recuperar os dados da conta.");
      print("Tente novamente mais tarde.");
    } finally {
      print("${DateTime.now()} | Ocorreu uma tentativa de consulta.");
      // Aqui vai rodar antes de fechar.
    }
    // Aqui não vai rodar antes de fechar.
  }

  _addExampleAccount() async {
    try {
      Account example = Account(
        id: "ID555",
        name: "Haley",
        lastName: "Chirívia",
        balance: 8001,
        accountType: "Brigadeiro",
      );

      await _accountService.addAccount(example);
    } on Exception {
      print("Ocorreu um problema ao tentar adicionar.");
    }
  }

  _makeNewTransaction() async {
    try {
      print("Digite o seu nome completo:");
      String nameOne = stdin.readLineSync()!;
      print("Digite o nome completo do destinatário:");
      String nameTwo = stdin.readLineSync()!;
      print("Digite o nome do destinatário:");
      String temp = stdin.readLineSync() ?? "0.0";
      double amount = double.parse(temp);

      Account senderAcc = await _accountService.getAccountByName(nameOne);
      Account receiverAcc = await _accountService.getAccountByName(nameTwo);

      _transactionService.makeTransaction(idSender: senderAcc.id, idReceiver: receiverAcc.id, amount: amount);
    } on Exception catch (e) {
      print(e);
    }
  }
}
