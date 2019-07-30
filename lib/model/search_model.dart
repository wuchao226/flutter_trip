///搜索模型
class SearchModel {
  final List<SearchItem> data;
  String keyword;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data =
        dataJson.map((i) => SearchItem.fromJson(i)).toList();
    return SearchModel(data: data);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['data'] = data;
    return data;
  }
}

class SearchItem {
  final String word; //xx酒店
  final String type; //hotel
  final String price; //实时计价
  final String star; //豪华型'
  final String zonename; //虹桥
  final String districtname; //上海
  final String url;

  SearchItem(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonename,
      this.districtname,
      this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      star: json['star'],
      zonename: json['zonename'],
      districtname: json['districtname'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['word'] = word;
    data['type'] = type;
    data['price'] = price;
    data['star'] = star;
    data['zonename'] = zonename;
    data['districtname'] = districtname;
    data['url'] = url;
    return data;
  }
}
