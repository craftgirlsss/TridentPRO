class TradingOrderHistoryModel {
  TradingOrderHistoryModel({
    this.response,
  });
  List<Response>? response;

  TradingOrderHistoryModel.fromJson(Map<String, dynamic> json){
    response = json['response'] == null ? [] : List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }
}

class Response {
  Response({
    this.ticket,
    this.profit,
    this.swap,
    this.commission,
    this.fee,
    this.closePrice,
    this.closeTime,
    this.closeLots,
    this.closeComment,
    this.openPrice,
    this.openTime,
    this.lots,
    this.expertId,
    this.placedType,
    this.orderType,
    this.dealType,
    this.symbol,
    this.comment,
    this.state,
    this.stopLoss,
    this.takeProfit,
    this.requestId,
    this.digits,
  });
  var ticket;
  var profit;
  var swap;
  var commission;
  var fee;
  var closePrice;
  var closeTime;
  var closeLots;
  var closeComment;
  var openPrice;
  var openTime;
  var lots;
  var expertId;
  var placedType;
  var orderType;
  var dealType;
  var symbol;
  var comment;
  var state;
  var stopLoss;
  var takeProfit;
  var requestId;
  var digits;

  Response.fromJson(Map<String, dynamic> json){
    ticket = json['ticket'];
    profit = json['profit'];
    swap = json['swap'];
    commission = json['commission'];
    fee = json['fee'];
    closePrice = json['closePrice'];
    closeTime = json['closeTime'];
    closeLots = json['closeLots'];
    closeComment = json['closeComment'];
    openPrice = json['openPrice'];
    openTime = json['openTime'];
    lots = json['lots'];
    expertId = json['expertId'];
    placedType = json['placedType'];
    orderType = json['orderType'];
    dealType = json['dealType'];
    symbol = json['symbol'];
    comment = json['comment'];
    state = json['state'];
    stopLoss = json['stopLoss'];
    takeProfit = json['takeProfit'];
    requestId = json['requestId'];
    digits = json['digits'];
  }
}