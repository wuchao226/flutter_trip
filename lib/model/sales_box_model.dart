import 'common_model.dart';

//活动入口模型
class SalesBoxModel {
  final String icon;
  final String moreUrl;
  final CommonModel bigCard1;
  final CommonModel bigCard2;
  final CommonModel smallCard1;
  final CommonModel smallCard2;
  final CommonModel smallCard3;
  final CommonModel smallCard4;

  SalesBoxModel(
      {this.icon,
      this.moreUrl,
      this.bigCard1,
      this.bigCard2,
      this.smallCard1,
      this.smallCard2,
      this.smallCard3,
      this.smallCard4});

  factory SalesBoxModel.fromJson(Map<String, dynamic> json) {
    return SalesBoxModel(
      icon: json['icon'],
      moreUrl: json['moreUrl'],
      bigCard1: CommonModel.fromJson(json['bigCard1']),
      bigCard2: CommonModel.fromJson(json['bigCard2']),
      smallCard1: CommonModel.fromJson(json['smallCard1']),
      smallCard2: CommonModel.fromJson(json['smallCard2']),
      smallCard3: CommonModel.fromJson(json['smallCard3']),
      smallCard4: CommonModel.fromJson(json['smallCard4']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['icon'] = icon;
    data['moreUrl'] = moreUrl;
    data['bigCard1'] = bigCard1;
    data['bigCard2'] = bigCard2;
    data['smallCard1'] = smallCard1;
    data['smallCard2'] = smallCard2;
    data['smallCard3'] = smallCard3;
    data['smallCard4'] = smallCard4;
    return data;
  }
}
