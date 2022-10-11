class Addresses {
  final int AddID;
  final String FathersMobile;
  final String MothersMobile;
  final String Address;
  final String KifleKetema;
  final String Woreda;
  final String HouseNum;
  final int StudentID;
  Addresses({
    required this.AddID,
    required this.FathersMobile,
    required this.MothersMobile,
    required this.Address,
    required this.KifleKetema,
    required this.Woreda,
    required this.HouseNum,
    required this.StudentID,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'AddID': AddID,
      'FathersMobile': FathersMobile,
      'MothersMobile': MothersMobile,
      'Address': Address,
      'KifleKetema': KifleKetema,
      'Woreda': Woreda,
      'HouseNum': HouseNum,
      'StudentID': StudentID,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Addresses{AddID: $AddID, FathersMobile: $FathersMobile, MothersMobile: $MothersMobile,Address: $Address, KifleKetema: $KifleKetema, Woreda: $Woreda,HouseNum:$HouseNum}';
  }
}