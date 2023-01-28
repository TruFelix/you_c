/// This is a self-Contract
///
/// It is used for the user to achieve what he wants
/// Everytime he fails to fulfill his contract, all contracts up to this point
/// will be 'ripped' = deleted.
class Contract {
  final String? id;

  final String title;

  /// What the user wants to achieve.
  final String content;

  /// Did the user achieve it?
  /// If `null` the user didn't tell yet.
  final bool fulfilled;

  const Contract({
    this.id,
    required this.title,
    required this.content,
    this.fulfilled = false,
  });

  Contract.fromStorage(String this.id, Map<String, dynamic> docData)
      : title = docData['title'],
        content = docData["content"],
        fulfilled = docData["fulfilled"];

  Map<String, dynamic> get forStorage => {
        "title": title,
        "content": content,
        "fulfilled": fulfilled,
      };
}
