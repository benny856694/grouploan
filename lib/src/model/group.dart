class Group {
  String id;
  String name;
  String accountNumber;
  String? description;
  String? phoneNumber;
  DateTime? registrationDate;
  String? leaderName;
  Group(
    this.id,
    this.name,
    this.accountNumber, {
    this.description,
    this.phoneNumber,
    this.registrationDate,
    this.leaderName,
  });
}
