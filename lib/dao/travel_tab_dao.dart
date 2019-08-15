

import 'package:ctrip_flutter/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///标签数据
class TravelTabDao {

  //接口 Url
  static const String TRAVEL_TAB_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';

  static Future<TravelTabModel> fetch() async {

    var response = await http.get(TRAVEL_TAB_URL);
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    }else {
      throw Exception('Failed to load travel_page.json');
    }

  }

}