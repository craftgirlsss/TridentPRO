class UserBankModel {
  UserBankModel({
    this.response,
  });
  List<Response>? response;

  UserBankModel.fromJson(Map<String, dynamic> json){
    response = json['response'] == null ? null : List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }
}

class Response {
  Response({
    this.id,
    this.name,
    this.account,
    this.branch,
    this.type,
    this.userName,
  });
  String? id;
  String? name;
  String? account;
  String? branch;
  String? type;
  String? userName;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    account = json['account'];
    branch = json['branch'];
    type = json['type'];
    userName = json['user_name'];
  }
}