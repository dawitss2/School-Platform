class Payments {
  final int PaymentID;
  final String AcYear;
  final String Month;
  final String Bank;
  final String Amount;
  final String Payment;
  final String Stamp;
  final int StudentID;

  Payments({
    required this.PaymentID,
    required this.AcYear,
    required this.Month,
    required this.Bank,
    required this.Amount,
    required this.Payment,
    required this.Stamp,
    required this.StudentID,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'PaymentID':PaymentID,
      'AcYear': AcYear,
      'Month': Month,
      'Bank': Bank,
      'Amount': Amount,
      'Payment': Payment,
      'Stamp': Stamp,
      'StudentID': StudentID,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Payments{PaymentID:$PaymentID,AcYear: $AcYear, Month: $Month, Bank: $Bank,Amount: $Amount, Payment: $Payment, Stamp: $Stamp}';
  }
}