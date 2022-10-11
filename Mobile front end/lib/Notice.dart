class Notice {
  final int NotificationID;
  final int StudentID;
  final String Title;
  final String Value;
  final String Type;
  final String AssignedTo;
  final String Seen;
  Notice({
    required this.NotificationID,
    required this.Title,
    required this.Value,
    required this.Type,
    required this.AssignedTo,
    required this.StudentID,
    required this.Seen,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'NotificationID': NotificationID,
      'Title': Title,
      'Value': Value,
      'Type': Type,
      'AssignedTo': AssignedTo,
      'StudentID': StudentID,
      'Seen':Seen,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Notice{NotificationID: $NotificationID, Title: $Title, Type: $Type,Value: $Value, AssignedTo: $AssignedTo,Seen : $Seen}';
  }
}