class AccountNameNotFoundException implements Exception {
  String message;

  AccountNameNotFoundException({this.message = "Não existe conta com o nome inserido."});
}