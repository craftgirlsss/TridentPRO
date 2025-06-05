class OpenOrderModel {
  OpenOrderModel({
    this.response,
  });
  List<Response>? response;

  OpenOrderModel.fromJson(Map<String, dynamic> json){
    response = json['response'] == null && json['response'] == [] ? [] : List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }
}

class Response {
  Response({
    this.ticket,
    this.openTime,
    this.timeUpdate,
    this.orderType,
    this.dealType,
    this.magic,
    this.digits,
    this.identifier,
    this.reason,
    this.volume,
    this.lots,
    this.openPrice,
    this.stopLoss,
    this.takeProfit,
    this.priceCurrent,
    this.swap,
    this.profit,
    this.symbol,
    this.comment,
    this.externalId,
  });
  int? ticket;
  String? openTime;
  String? timeUpdate;
  String? orderType;
  String? dealType;
  int? magic;
  int? digits;
  int? identifier;
  int? reason;
  int? volume;
  int? lots;
  double? openPrice;
  int? stopLoss;
  int? takeProfit;
  double? priceCurrent;
  int? swap;
  double? profit;
  String? symbol;
  String? comment;
  String? externalId;

  Response.fromJson(Map<String, dynamic> json){
    ticket = json['ticket'];
    openTime = json['openTime'];
    timeUpdate = json['time_update'];
    orderType = json['orderType'];
    dealType = json['dealType'];
    magic = json['magic'];
    digits = json['digits'];
    identifier = json['identifier'];
    reason = json['reason'];
    volume = json['volume'];
    lots = json['lots'];
    openPrice = json['openPrice'];
    stopLoss = json['stopLoss'];
    takeProfit = json['takeProfit'];
    priceCurrent = json['price_current'];
    swap = json['swap'];
    profit = json['profit'];
    symbol = json['symbol'];
    comment = json['comment'];
    externalId = json['external_id'];
  }
}