class AccountModel {
  int? id;
  String? type;
  String? typeAcc;
  String? country;
  String? idType;
  String? idNumber;
  String? appFotoIdentitas;
  String? appFotoTerbaru;
  String? appFotoPendukung;
  String? appFotoPendukung2;
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
  String? app_foto_simulasi;

  String? tujuan_investasi;
  String? pengalaman_investasi;
  String? pengalaman_investasi_bidang;
  String? kerja_nama;
  String? kerja_tipe;
  String? kerja_bidang;
  String? kerja_jabatan;
  String? kerja_lama;
  String? kerja_lama_sebelum;
  String? kerja_alamat;
  String? kerja_zip;
  String? kerja_telepon;
  String? kerja_fax;
  String? kekayaan;
  String? kekayaan_rumah_lokasi;
  String? kekayaan_njop;
  String? kekayaan_deposit;
  String? kekayaan_nilai;
  String? kekayaan_lain;
  String? keluarga_bursa;
  String? pernyataan_pailit;

  AccountModel({
    this.id,
    this.type,
    this.app_foto_simulasi,
    this.typeAcc,
    this.country,
    this.idType,
    this.idNumber,
    this.appFotoIdentitas,
    this.appFotoTerbaru,
    this.appFotoPendukung,
    this.appFotoPendukung2,
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

    this.kekayaan,
    this.kekayaan_deposit,
    this.kekayaan_lain,
    this.kekayaan_nilai,
    this.kekayaan_njop,
    this.kekayaan_rumah_lokasi,
    this.kerja_alamat,
    this.kerja_bidang,
    this.kerja_fax,
    this.kerja_jabatan,
    this.kerja_lama,
    this.kerja_lama_sebelum,
    this.kerja_nama,
    this.kerja_telepon,
    this.kerja_tipe,
    this.kerja_zip,
    this.pengalaman_investasi,
    this.pengalaman_investasi_bidang,
    this.tujuan_investasi,
    this.pernyataan_pailit,
    this.keluarga_bursa
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
      appFotoPendukung: json['app_foto_pendukung'],
      appFotoPendukung2: json['app_foto_pendukung_lainnya'],
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
      app_foto_simulasi: json['app_foto_simulasi'],
      drrtPostalCode: json['drrt_postal_code'],
      kekayaan: json['kekayaan'],
      kekayaan_deposit: json['kekayaan_deposit'],
      kekayaan_lain: json['kekayaan_lain'],
      kekayaan_nilai: json['kekayaan_nilai'],
      kekayaan_njop: json['kekayaan_njop'],
      kekayaan_rumah_lokasi: json['kekayaan_rumah_lokasi'],
      kerja_alamat: json['kerja_alamat'],
      kerja_bidang: json['kerja_bidang'],
      kerja_fax: json['kerja_fax'],
      kerja_jabatan: json['kerja_jabatan'],
      kerja_lama: json['kerja_lama'],
      kerja_lama_sebelum: json['kerja_lama_sebelum'],
      kerja_nama: json['kerja_nama'],
      kerja_telepon: json['kerja_telepon'],
      kerja_tipe: json['kerja_tipe'],
      kerja_zip: json['kerja_zip'],
      pengalaman_investasi: json['pengalaman_investasi'],
      pengalaman_investasi_bidang: json['pengalaman_investasi_bidang'],
      tujuan_investasi: json['tujuan_investasi'],
      pernyataan_pailit: json['pernyataan_pailit'],
      keluarga_bursa: json['keluarga_bursa']
    );
  }
}
