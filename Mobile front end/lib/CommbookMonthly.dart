class Commbookmonthly {
  final int CommbookID;
  final String CommitemID;
  final int StudentID;
  final String Value;
  final String Month;
  final String MonthName;
  final String commitem;
  Commbookmonthly({
    required this.CommbookID,
    required this.CommitemID,
    required this.StudentID,
    required this.Value,
    required this.Month,
    required this.MonthName,
    required this.commitem,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'CommbookID': CommbookID,
      'CommitemID': CommitemID,
      'StudentID': StudentID,
      'Value': Value,
      'Month': Month,
      'MonthName': MonthName,
      'commitem': commitem,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Commbookmonthly{CommbookID: $CommbookID, CommitemID: $CommitemID, StudentID: $StudentID,Value: $Value, Month: $Month,MonthName: $MonthName, commitem: $commitem}';
  }
}