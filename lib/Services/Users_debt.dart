import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// ==========================================
// DATA MODELS & JSON PARSER
// ==========================================

UsersDebts usersDebtsFromJson(String str) => UsersDebts.fromJson(json.decode(str));

String usersDebtsToJson(UsersDebts data) => json.encode(data.toJson());

class UsersDebts {
  UsersDebts({
    required this.data,
  });

  final List<DebtDatum> data;

  factory UsersDebts.fromJson(Map<String, dynamic> json) => UsersDebts(
        data: List<DebtDatum>.from(
            json["data"].map((x) => DebtDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DebtDatum {
  DebtDatum({
    required this.id,
    required this.userName,
    required this.title,
    required this.amount,
    required this.isPaid,
    this.description = '',
    this.imageUrl = '',
  });

  final int id;
  final String userName;
  final String title;
  final double amount;
  bool isPaid;
  final String description;
  final String imageUrl;

  factory DebtDatum.fromJson(Map<String, dynamic> json) => DebtDatum(
        id: json["id"] ?? 0,
        userName: json["userName"] ?? '',
        title: json["title"] ?? '',
        amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
        isPaid: json["isPaid"] ?? false,
        description: json["description"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "title": title,
        "amount": amount,
        "isPaid": isPaid,
        "description": description,
        "imageUrl": imageUrl,
      };
}

// ==========================================
// DEBT SERVICE LAYER
// ==========================================

class DebtService {
  /// Fetch debt list from assets/users_debts.json
  Future<List<DebtDatum>> loadDebtsFromAsset() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/users_debts.json');
      final UsersDebts parsedData = usersDebtsFromJson(jsonString);
      return parsedData.data;
    } catch (e) {
      throw Exception('Failed to load debts: $e');
    }
  }
}