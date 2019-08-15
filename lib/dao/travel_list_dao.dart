

import 'package:ctrip_flutter/model/travel_list_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var params = {
  "groupChannelCode": "tourphoto_global1",
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
  }
};


/// Tab 详情列表
class TravelListDao {

  //接口 Url
  static const String DEFAULT_TRAVEL_URL = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

  static Future<TravelListModel> fetch(String travelUrl, String groupChannelCode,  int pageIndex, int pageSize) async {

    //构建需要的参数
    Map pageParam = params['pagePara'];
    pageParam['pageIndex'] = pageIndex;
    pageParam['pageSize'] = pageSize;
    params['groupChannelCode'] = groupChannelCode;

    var response = await http.post(travelUrl ?? DEFAULT_TRAVEL_URL, body: jsonEncode(params));
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelListModel.fromJson(result);
    }else {
      throw Exception('Failed to load travel list');
    }

  }

}