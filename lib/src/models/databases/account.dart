class AccountModel {
  final int? id;
  final int? type;
  final int? typeAcc;
  final String? country;
  final String? idType;
  final String? idNumber;
  final String? appFotoIdentitas;
  final String? appFotoTerbaru;
  final String? npwp;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? gender;
  final String? province;
  final String? city;
  final String? district;
  final String? village;
  final String? address;
  final String? postalCode;
  final String? motherName;
  final String? phoneHome;
  final String? faxHome;
  final String? phoneNumber;
  final String? drrtName;
  final String? drrtStatus;
  final String? drrtPhone;
  final String? drrtAddress;
  final String? drrtPostalCode;

  AccountModel({
    this.id,
    this.type,
    this.typeAcc,
    this.country,
    this.idType,
    this.idNumber,
    this.appFotoIdentitas,
    this.appFotoTerbaru,
    this.npwp,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
    this.province,
    this.city,
    this.district,
    this.village,
    this.address,
    this.postalCode,
    this.motherName,
    this.phoneHome,
    this.faxHome,
    this.phoneNumber,
    this.drrtName,
    this.drrtStatus,
    this.drrtPhone,
    this.drrtAddress,
    this.drrtPostalCode,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      type: json['type'],
      typeAcc: json['type_acc'],
      country: json['country'],
      idType: json['id_type'],
      idNumber: json['id_number'],
      appFotoIdentitas: json['app_foto_identitas'],
      appFotoTerbaru: json['app_foto_terbaru'],
      npwp: json['npwp'],
      dateOfBirth: json['date_of_birth'],
      placeOfBirth: json['place_of_birth'],
      gender: json['gender'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      village: json['village'],
      address: json['address'],
      postalCode: json['postal_code'],
      motherName: json['mother_name'],
      phoneHome: json['phone_home'],
      faxHome: json['fax_home'],
      phoneNumber: json['phone_number'],
      drrtName: json['drrt_name'],
      drrtStatus: json['drrt_status'],
      drrtPhone: json['drrt_phone'],
      drrtAddress: json['drrt_address'],
      drrtPostalCode: json['drrt_postal_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'typeAcc': typeAcc,
      'country': country,
      'idType': idType,
      'idNumber': idNumber,
      'appFotoIdentitas': appFotoIdentitas,
      'appFotoTerbaru': appFotoTerbaru,
      'npwp': npwp,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'gender': gender,
      'province': province,
      'city': city,
      'district': district,
      'village': village,
      'address': address,
      'postalCode': postalCode,
      'motherName': motherName,
      'phoneHome': phoneHome,
      'faxHome': faxHome,
      'phoneNumber': phoneNumber,
      'drrtName': drrtName,
      'drrtStatus': drrtStatus,
      'drrtPhone': drrtPhone,
      'drrtAddress': drrtAddress,
      'drrtPostalCode': drrtPostalCode,
    };
  }
}
