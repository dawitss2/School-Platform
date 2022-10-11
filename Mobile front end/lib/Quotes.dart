class Quotes {
  final int QuoteID;
  final String Author;
  final String Quote ;
  Quotes({
    required this.QuoteID,
    required this.Author,
    required this.Quote,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'QuoteID': QuoteID,
      'Author': Author,
      'Quote ': Quote ,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Quotes{QuoteID: $QuoteID, Author: $Author, Quote : $Quote }';
  }
}