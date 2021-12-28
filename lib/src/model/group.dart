import 'dart:convert';

class Group {
  String id = '';
  String name = '';
  String accountNumber = '';
  String? description;
  String? phoneNumber;
  DateTime? registrationDate;
  String? leaderName;
  double? latitude;
  double? longitude;
  Group({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.description,
    this.phoneNumber,
    this.registrationDate,
    this.leaderName,
    this.latitude,
    this.longitude,
  });

  Group copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? description,
    String? phoneNumber,
    DateTime? registrationDate,
    String? leaderName,
    double? latitude,
    double? longitude,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      registrationDate: registrationDate ?? this.registrationDate,
      leaderName: leaderName ?? this.leaderName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      description: map['description'],
      phoneNumber: map['phoneNumber'],
      registrationDate: map['registrationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['registrationDate'])
          : null,
      leaderName: map['leaderName'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, name: $name, accountNumber: $accountNumber, description: $description, phoneNumber: $phoneNumber, registrationDate: $registrationDate, leaderName: $leaderName, latitude: $latitude, longitude: $longitude)';
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
        other.leaderName == leaderName &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        accountNumber.hashCode ^
        description.hashCode ^
        phoneNumber.hashCode ^
        registrationDate.hashCode ^
        leaderName.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
