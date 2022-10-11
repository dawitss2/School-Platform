class Commbookweekly {
  final int CommbookID;
  final String CommitemID;
  final int StudentID;
  final String Value;
  final String WeekID;
  final String WeekName;
  final String commitem;
  Commbookweekly({
    required this.CommbookID,
    required this.CommitemID,
    required this.StudentID,
    required this.Value,
    required this.WeekID,
    required this.WeekName,
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
      'WeekID': WeekID,
      'WeekName': WeekName,
      'commitem': commitem,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Commbookweekly{CommbookID: $CommbookID, CommitemID: $CommitemID, StudentID: $StudentID,Value: $Value, WeekID: $WeekID,WeekName: $WeekName, commitem: $commitem}';
  }
}