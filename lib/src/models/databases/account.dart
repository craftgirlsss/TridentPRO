class AccountModel {
  int? id;
  String? type;
  String? typeAcc;
  String? country;
  String? idType;
  String? idNumber;
  String? appFotoIdentitas;
  String? appFotoTerbaru;
  String? npwp;
  String? dateOfBirth;
  String? placeOfBirth;
  String? gender;
  String? province;
  String? city;
  String? district;
  String? village;
  String? address;
  String? postalCode;
  String? maritalStatus;
  String? wifeName;
  String? motherName;
  String? phoneHome;
  String? faxHome;
  String? phoneNumber;
  String? drrtName;
  String? drrtStatus;
  String? drrtPhone;
  String? drrtAddress;
  String? drrtPostalCode;
  String? rt;
  String? rw;

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
    this.maritalStatus,
    this.rt,
    this.rw,
    this.wifeName,
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
      rt: json['rt'],
      rw: json['rw'],
      address: json['address'],
      postalCode: json['postal_code'],
      maritalStatus: json['marital_status'],
      wifeName: json['wife_name'],
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
      'maritalStatus': maritalStatus,
      'wifeName': wifeName,
      'motherName': motherName,
      'phoneHome': phoneHome,
      'faxHome': faxHome,
      'phoneNumber': phoneNumber,
      'drrtName': drrtName,
      'drrtStatus': drrtStatus,
      'drrtPhone': drrtPhone,
      'drrtAddress': drrtAddress,
      'drrtPostalCode': drrtPostalCode,
      'rt' : rt,
      'rw' : rw
    };
  }
}
