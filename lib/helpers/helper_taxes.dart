import 'package:dart_assincronismo/models/account.dart';

class HelperTaxes {
  double calculateTaxesByAccount(Account account, double ammount) {
    if (ammount < 5000) return 0.0;

    switch (account.accountType.toLowerCase()) {
      case "ambrosia":
        return (0.5 / 100) * ammount;
      case "canjica":
        return (0.33 / 100) * ammount;
      case "pudim":
        return (0.25 / 100) * ammount;
      case "brigadeiro":
        return (0.01 / 100) * ammount;
      default:
        print("Tipo de conta inválido");
        return 0.0;
    }
  }
}
