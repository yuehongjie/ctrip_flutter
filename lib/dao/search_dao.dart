

import 'package:ctrip_flutter/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchDao {

  //搜索接口 Url
  static const String SEARCH_URL_PRE = 'http://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

  static Future<SearchModel> fetch(String keyword) async {

    var response = await http.get('$SEARCH_URL_PRE$keyword');
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      var searchModel = SearchModel.fromJson(result);
      //优化：当返回数据的关键字和输入框中的关键字一样时，才刷新 UI
      searchModel.keyword = keyword;
      return searchModel;
    }else {
      throw Exception('Failed to load search_page.json');
    }

  }

}