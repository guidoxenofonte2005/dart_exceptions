// import 'package:dart_assincronismo/screens/account_screen.dart';
import 'package:dart_assincronismo/services/transaction_service.dart';

void main() {
  // AccountScreen accountScreen = AccountScreen();
  // accountScreen.initializeStream();
  // accountScreen.runChatBot();
  TransactionService transactionService = TransactionService();
  transactionService.makeTransaction(senderID: "ID001", receiverID: "ID004", ammount: 40000.0);
}

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