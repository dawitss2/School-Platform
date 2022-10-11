class Results {
  final int ResultID;
  final String AssesmentID;
  final String SubjectName;
  final String Name;
  final String Value;
  final String Result;
  final int StudentID;
  Results({
    required this.ResultID,
    required this.AssesmentID,
    required this.SubjectName,
    required this.Name,
    required this.Value,
    required this.Result,
    required this.StudentID,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'ResultID':ResultID,
      'AssesmentID': AssesmentID,
      'SubjectName': SubjectName,
      'Name': Name,
      'Value': Value,
      'Result': Result,
      'StudentID': StudentID,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Results{ResultID:$ResultID,AssesmentID: $AssesmentID, SubjectName: $SubjectName, Name: $Name,Value: $Value, Result: $Result,Student:$StudentID}';
  }
}