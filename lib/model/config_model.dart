class ConfigModel {
  final String searchUrl;

  ConfigModel({this.searchUrl});

  //Map 转 Object
  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  //object 转 map
  Map<String, dynamic> toJson() {
    return {searchUrl: searchUrl};
  }
}
