
class Subject {
  final String SubjectName;
  final double Completed;
  Subject({
    required this.SubjectName,
    required this.Completed
  });
// Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic>  toMap() {
    return {
      'SubjectName': SubjectName,
      'Completed': Completed,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Subjects{SubjectName: $SubjectName, Completed: $Completed}';
  }
}