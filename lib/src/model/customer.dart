import 'dart:convert';

import 'package:flutter/foundation.dart';

// - Customer ID (auto-generated Numbers Only TimeStamp will be OK)
//  - Name of Customer
//  - Verification Type (Voters ID, Ghana Card)
//  - Identification Number

//  - Home Location Latitude
//  - Home Location Longitude
//   - Business Location Latitude
//   - Business Location Longitude
//  -Telephone Number
//  -Next of kin (Name)
//  -Next of Kin Telephone
//  - Next of Kin Location Latitude
//  - Next of Kin Location Longitude
//  - Pictures 3 Pictures

//           a.Front View ,
//           b.Back View
//           c.Person Holding the ID Card
// - Added By (currently logged in User)

//  - Approval Status ( Pending, Approved, Rejected)
//  -Approved By (Current Logged In Staff)

enum VerificationType {
  votersID,
  ghanaCard,
}

enum ApproveStatus {
  pending,
  approved,
  rejected,
}

class Customer {
  final String id;
  final String name;
  String get nameLowerCase => name.toLowerCase();
  // enum
  final VerificationType verificationType;
  final String identificationNumber;
  final double? homeLocationLatitude;
  final double? homeLocationLongitude;
  final double? businessLocationLatitude;
  final double? businessLocationLongitude;
  final String? telephoneNumber;
  final String? nextOfKinName;
  final String? nextOfKinTelephone;
  final double? nextOfKinLocationLatitude;
  final double? nextOfKinLocationLongitude;

  final String addedByStaffId;
  final String addedByStaffName;

  // enum
  final ApproveStatus approveStatus;
  final String approvedByStaffId;
  final String approvedByStaffName;

  final List<String>? pictures;
  Customer({
    required this.id,
    required this.name,
    required this.verificationType,
    required this.identificationNumber,
    this.homeLocationLatitude,
    this.homeLocationLongitude,
    this.businessLocationLatitude,
    this.businessLocationLongitude,
    this.telephoneNumber,
    this.nextOfKinName,
    this.nextOfKinTelephone,
    this.nextOfKinLocationLatitude,
    this.nextOfKinLocationLongitude,
    required this.addedByStaffId,
    required this.addedByStaffName,
    required this.approveStatus,
    required this.approvedByStaffId,
    required this.approvedByStaffName,
    this.pictures,
  });

  Customer copyWith({
    String? id,
    String? name,
    VerificationType? verificationType,
    String? identificationNumber,
    double? homeLocationLatitude,
    double? homeLocationLongitude,
    double? businessLocationLatitude,
    double? businessLocationLongitude,
    String? telephoneNumber,
    String? nextOfKinName,
    String? nextOfKinTelephone,
    double? nextOfKinLocationLatitude,
    double? nextOfKinLocationLongitude,
    String? addedByStaffId,
    String? addedByStaffName,
    ApproveStatus? approveStatus,
    String? approvedByStaffId,
    String? approvedByStaffName,
    List<String>? pictures,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      verificationType: verificationType ?? this.verificationType,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      homeLocationLatitude: homeLocationLatitude ?? this.homeLocationLatitude,
      homeLocationLongitude:
          homeLocationLongitude ?? this.homeLocationLongitude,
      businessLocationLatitude:
          businessLocationLatitude ?? this.businessLocationLatitude,
      businessLocationLongitude:
          businessLocationLongitude ?? this.businessLocationLongitude,
      telephoneNumber: telephoneNumber ?? this.telephoneNumber,
      nextOfKinName: nextOfKinName ?? this.nextOfKinName,
      nextOfKinTelephone: nextOfKinTelephone ?? this.nextOfKinTelephone,
      nextOfKinLocationLatitude:
          nextOfKinLocationLatitude ?? this.nextOfKinLocationLatitude,
      nextOfKinLocationLongitude:
          nextOfKinLocationLongitude ?? this.nextOfKinLocationLongitude,
      addedByStaffId: addedByStaffId ?? this.addedByStaffId,
      addedByStaffName: addedByStaffName ?? this.addedByStaffName,
      approveStatus: approveStatus ?? this.approveStatus,
      approvedByStaffId: approvedByStaffId ?? this.approvedByStaffId,
      approvedByStaffName: approvedByStaffName ?? this.approvedByStaffName,
      pictures: pictures ?? this.pictures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameLowerCase': nameLowerCase,
      'verificationType': verificationType.index,
      'identificationNumber': identificationNumber,
      'homeLocationLatitude': homeLocationLatitude,
      'homeLocationLongitude': homeLocationLongitude,
      'businessLocationLatitude': businessLocationLatitude,
      'businessLocationLongitude': businessLocationLongitude,
      'telephoneNumber': telephoneNumber,
      'nextOfKinName': nextOfKinName,
      'nextOfKinTelephone': nextOfKinTelephone,
      'nextOfKinLocationLatitude': nextOfKinLocationLatitude,
      'nextOfKinLocationLongitude': nextOfKinLocationLongitude,
      'addedByStaffId': addedByStaffId,
      'addedByStaffName': addedByStaffName,
      'approveStatus': approveStatus.index,
      'approvedByStaffId': approvedByStaffId,
      'approvedByStaffName': approvedByStaffName,
      'pictures': pictures,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      verificationType: VerificationType.values[map['verificationType'] ?? 0],
      identificationNumber: map['identificationNumber'] ?? '',
      homeLocationLatitude: map['homeLocationLatitude']?.toDouble(),
      homeLocationLongitude: map['homeLocationLongitude']?.toDouble(),
      businessLocationLatitude: map['businessLocationLatitude']?.toDouble(),
      businessLocationLongitude: map['businessLocationLongitude']?.toDouble(),
      telephoneNumber: map['telephoneNumber'],
      nextOfKinName: map['nextOfKinName'],
      nextOfKinTelephone: map['nextOfKinTelephone'],
      nextOfKinLocationLatitude: map['nextOfKinLocationLatitude']?.toDouble(),
      nextOfKinLocationLongitude: map['nextOfKinLocationLongitude']?.toDouble(),
      addedByStaffId: map['addedByStaffId'] ?? '',
      addedByStaffName: map['addedByStaffName'] ?? '',
      approveStatus: ApproveStatus.values[map['approveStatus'] ?? 0],
      approvedByStaffId: map['approvedByStaffId'] ?? '',
      approvedByStaffName: map['approvedByStaffName'] ?? '',
      pictures: List<String>.from(map['pictures']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, verificationType: $verificationType, identificationNumber: $identificationNumber, homeLocationLatitude: $homeLocationLatitude, homeLocationLongitude: $homeLocationLongitude, businessLocationLatitude: $businessLocationLatitude, businessLocationLongitude: $businessLocationLongitude, telephoneNumber: $telephoneNumber, nextOfKinName: $nextOfKinName, nextOfKinTelephone: $nextOfKinTelephone, nextOfKinLocationLatitude: $nextOfKinLocationLatitude, nextOfKinLocationLongitude: $nextOfKinLocationLongitude, addedByStaffId: $addedByStaffId, addedByStaffName: $addedByStaffName, approveStatus: $approveStatus, approvedByStaffId: $approvedByStaffId, approvedByStaffName: $approvedByStaffName, pictures: $pictures)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        verificationType.hashCode ^
        identificationNumber.hashCode ^
        homeLocationLatitude.hashCode ^
        homeLocationLongitude.hashCode ^
        businessLocationLatitude.hashCode ^
        businessLocationLongitude.hashCode ^
        telephoneNumber.hashCode ^
        nextOfKinName.hashCode ^
        nextOfKinTelephone.hashCode ^
        nextOfKinLocationLatitude.hashCode ^
        nextOfKinLocationLongitude.hashCode ^
        addedByStaffId.hashCode ^
        addedByStaffName.hashCode ^
        approveStatus.hashCode ^
        approvedByStaffId.hashCode ^
        approvedByStaffName.hashCode ^
        pictures.hashCode;
  }
}
