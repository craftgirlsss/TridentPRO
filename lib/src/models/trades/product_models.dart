class ProductModels {
  ProductModels({
    required this.success,
    required this.data,
  });
  late final bool success;
  late final List<Data> data;

  ProductModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    required this.type,
    required this.products,
  });
  late final String type;
  late final List<Products> products;

  Data.fromJson(Map<String, dynamic> json){
    type = json['type'];
    products = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
  }
}

class Products {
  Products({
    this.suffix,
    this.name,
    this.rate,
    this.currency,
  });
  String? suffix;
  String? name;
  String? rate;
  String? currency;

  Products.fromJson(Map<String, dynamic> json){
    suffix = json['suffix'];
    name = json['name'];
    rate = json['rate'];
    currency = null;
  }
}