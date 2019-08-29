import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/travel_tab_model.dart';

const TRAVEL_TAB_URL =
    'https://apk-1256738511.file.myqcloud.com/FlutterTrip/data/travel_page.json';

///旅拍类别接口
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(TRAVEL_TAB_URL);
    if (response.statusCode == 200) {
      //fix 中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}
