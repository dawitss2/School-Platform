class distnictdata {
  final String val;

  distnictdata({
    required this.val,
  });
// Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic>  toMap() {
    return {
      'val': val,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'disnictdata{val: $val}';
  }
}