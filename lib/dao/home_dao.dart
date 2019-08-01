

import 'package:ctrip_flutter/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeDao {

  //首页接口 Url
  static const String HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

  static Future<HomeModel> fetch() async {

    var response = await http.get(HOME_URL);
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else {
      throw Exception('Failed to load home_page.json');
    }

  }

}