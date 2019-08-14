

import 'package:ctrip_flutter/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var Params = {
  "groupChannelCode": "tourphoto_global1",
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
  }
};

class TravelDao {

  //搜索接口 Url
  static const String TRAVEL_URL_PRE = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

  static Future<String> fetch(String groupChannelCode, int pageIndex, int pageSize) async {

    Map pageParam = Params['pagePara'];
    pageParam['pageIndex'] = pageIndex;
    pageParam['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;

    var response = await http.post(TRAVEL_URL_PRE, body: jsonEncode(Params));
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
//      var searchModel = SearchModel.fromJson(result);
      //优化：当返回数据的关键字和输入框中的关键字一样时，才刷新 UI
//      searchModel.keyword = keyword;

      return response.body;
    }else {
      throw Exception('Failed to load search_page.json');
    }

  }

}