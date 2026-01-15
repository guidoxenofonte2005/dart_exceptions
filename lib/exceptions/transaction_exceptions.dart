import 'package:dart_assincronismo/models/account.dart';

class SenderDoNotExistException implements Exception {
  final String message;

  SenderDoNotExistException({this.message = "Remetente não existe."});
}

class ReceiverDoNotExistException implements Exception {
  final String message;

  ReceiverDoNotExistException({this.message = "Destinatário não existe."});
}

class InsufficientFundsException implements Exception {
  String message;
  Account sender;
  double amount;
  double taxes;

  InsufficientFundsException({
    this.message = "Fundos insuficientes para a transação.",
    required this.sender,
    required this.amount,
    required this.taxes,
  });
}
