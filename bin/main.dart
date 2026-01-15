// import 'package:dart_assincronismo/screens/account_screen.dart';
import 'package:dart_assincronismo/exceptions/transaction_exceptions.dart';
import 'package:dart_assincronismo/services/transaction_service.dart';

void main() {
  TransactionService()
      .makeTransaction(senderID: "ID001", receiverID: "ID004", ammount: 40000.0)
      .catchError((e) {
        print(e.message);
        print(
          "${e.sender.name} | Saldo total: R\$${e.sender.balance}, Saldo necessário: R\$${e.amount + e.taxes}",
        );
      }, test: (error) => error is InsufficientFundsException);
}

// void main() async {
//   // AccountScreen accountScreen = AccountScreen();
//   // accountScreen.initializeStream();
//   // accountScreen.runChatBot();
//   try {
//     TransactionService transactionService = TransactionService();
//     await transactionService.makeTransaction(
//       senderID: "ID001",
//       receiverID: "ID004",
//       ammount: 40000.0,
//     );
//   } on InsufficientFundsException catch (e) {
//     print(e.message);
//     print(
//       "${e.sender.name} | Saldo total: R\$${e.sender.balance}, Saldo necessário: R\$${e.amount + e.taxes}",
//     );
//   }
// }

// void main() {
//   print("Início da main");
//   function01();
//   print("Fim da main");
// }

// void function01() {
//   print("Inicio da function01");
//   function02();
//   print("Fim da function01");
// }

// void function02() {
//   print("Inicio da function02");
//   for (int i = 0; i < 5; i++) {
//     print(i);
//   }
//   print("Fim da function02");
// }
