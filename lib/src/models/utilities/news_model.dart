class NewsModel {
  NewsModel({
    required this.response,
  });
  late final List<Response> response;

  NewsModel.fromJson(Map<String, dynamic> json){
    response = List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }
}

class Response {
  Response({
    this.id,
    this.title,
    this.type,
    this.message,
    this.author,
    this.tanggal,
    this.picture,
  });
  String? id;
  String? title;
  String? type;
  String? message;
  String? author;
  String? tanggal;
  String? picture;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    type = json['type'];
    message = json['message'];
    author = json['author'];
    tanggal = json['tanggal'];
    picture = json['picture'];
  }
}