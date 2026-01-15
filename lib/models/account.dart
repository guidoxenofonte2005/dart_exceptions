// "data class" ou "model"
import 'dart:convert';

class Account {
  String id;
  String name;
  String lastName;
  double balance;
  String accountType;

  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
    required this.accountType,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map["id"],
      name: map["name"],
      lastName: map["lastName"],
      balance: map["balance"],
      accountType: map["accountType"] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "lastName": lastName,
      "balance": balance,
      "accountType": accountType,
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? lastName,
    double? balance,
    String? accountType
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      balance: balance ?? this.balance,
      accountType: accountType ?? this.accountType,
    );
  }

  String toJson(Account account) {
    return json.encode(account.toMap());
  }

  factory Account.fromJson(String jsonStr) =>
      Account.fromMap(json.decode(jsonStr));

  @override
  bool operator ==(covariant Account other) {
    // usa covariant pra definir o subtipo de objeto, nesse caso account
    if (identical(this, other)) return true;

    return id == other.id &&
        name == other.name &&
        lastName == other.lastName &&
        balance == other.balance;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ lastName.hashCode ^ balance.hashCode;

  @override
  String toString() {
    return "Conta $id;\n$name $lastName;\nSaldo: $balance\n";
  }
}
