import 'dart:convert';

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

  Group copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? description,
    String? phoneNumber,
    DateTime? registrationDate,
    String? leaderName,
  }) {
    return Group(
      id ?? this.id,
      name ?? this.name,
      accountNumber ?? this.accountNumber,
      description:  description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      registrationDate: registrationDate ?? this.registrationDate,
      leaderName: leaderName ?? this.leaderName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'description': description,
      'phoneNumber': phoneNumber,
      'registrationDate': registrationDate?.millisecondsSinceEpoch,
      'leaderName': leaderName,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      map['id'] ?? '',
      map['name'] ?? '',
      map['accountNumber'] ?? '',
      description: map['description'],
      phoneNumber: map['phoneNumber'],
      registrationDate: map['registrationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['registrationDate'])
          : null,
      leaderName: map['leaderName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, name: $name, accountNumber: $accountNumber, description: $description, phoneNumber: $phoneNumber, registrationDate: $registrationDate, leaderName: $leaderName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.id == id &&
        other.name == name &&
        other.accountNumber == accountNumber &&
        other.description == description &&
        other.phoneNumber == phoneNumber &&
        other.registrationDate == registrationDate &&
        other.leaderName == leaderName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        accountNumber.hashCode ^
        description.hashCode ^
        phoneNumber.hashCode ^
        registrationDate.hashCode ^
        leaderName.hashCode;
  }
}
