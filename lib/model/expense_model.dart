class ExpenseModel {
  final int? id;
  final int amount;
  final String reason;

  ExpenseModel({this.id,required this.amount, required this.reason});

  ExpenseModel copyWith({
    int? id,
    int? amount,
    String? reason,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount, 
      reason: reason ?? this.reason);
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'amount':amount,
      'reason':reason,
    };
  }

  factory
  ExpenseModel.fromMap(Map<String,dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      amount: map['amount'], 
      reason: map['reason'],
      );
  }


}