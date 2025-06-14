class TicketModels {
  TicketModels({
    required this.response,
  });
  late final List<Response> response;

  TicketModels.fromJson(Map<String, dynamic> json){
    response = List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }
}

class Response {
  Response({
    this.id,
    this.time,
    this.content,
    this.type,
  });
  String? id;
  String? time;
  String? content;
  String? type;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    time = json['time'];
    content = json['content'];
    type = json['type'];
  }
}