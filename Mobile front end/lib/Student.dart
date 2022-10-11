
class Student {
  final int StudentID;
  String img;
  final String Name;
  final String Gender;
  final String GradeName;
  final String Section;
  Student({
    required this.StudentID,
    required this.img,
    required this.Name,
    required this.Gender,
    required this.GradeName,
    required this.Section,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'StudentID': StudentID,
      'img': img,
      'Name': Name,
      'Gender': Gender,
      'GradeName': GradeName,
      'Section': Section,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Student{StudentID: $StudentID, img: $img, Name: $Name,Gender: $Gender, GradeName: $GradeName, Section: $Section}';
  }

}