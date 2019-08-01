
/*

首页网格卡片模型

 {
     hotel,
     flight,
     travel
 }

*/
import 'common_model.dart';

class GridNavModel{

  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return json == null ? null :

    GridNavModel(
      hotel: GridNavItem.fromJson(json['hotel']),
      flight: GridNavItem.fromJson(json['flight']),
      travel: GridNavItem.fromJson(json['travel']),
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hotel != null) {
      data['hotel'] = this.hotel.toJson();
    }
    if (this.flight != null) {
      data['flight'] = this.flight.toJson();
    }
    if (this.travel != null) {
      data['travel'] = this.travel.toJson();
    }
    return data;
  }

}



/*
 GridNavModel item
   {
      "startColor": "fa5956",
      "endColor": "fa9b4d",
      "mainItem": {
        "title": "酒店",
        "icon": "https://pic.c-ctrip.com/platform/h5/home/grid-nav-items-hotel.png",
        "url": "https://m.ctrip.com/webapp/hotel/",
        "statusBarColor": "4289ff"
      },
      "item1": {
        "title": "海外酒店",
        "url": "https://m.ctrip.com/webapp/hotel/oversea/?otype=1",
        "statusBarColor": "4289ff"
      },
      "item2": {
        "title": "特价酒店",
        "url": "https://m.ctrip.com/webapp/hotel/hotsale"
      },
      "item3": {
        "title": "团购",
        "url": "https://m.ctrip.com/webapp/tuan/?secondwakeup=true&dpclickjump=true",
        "hideAppBar": true
      },
      "item4": {
        "title": "民宿 客栈",
        "url": "https://m.ctrip.com/webapp/inn/index",
        "hideAppBar": true
      }

  }
 */
class GridNavItem {

  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem({this.startColor, this.endColor, this.mainItem, this.item1, this.item2, this.item3, this.item4});


  factory GridNavItem.fromJson(Map<String, dynamic> json) {

    return json != null ?

    GridNavItem(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: CommonModel.fromJson(json['mainItem']),
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
      
      
    ) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startColor'] = this.startColor;
    data['endColor'] = this.endColor;
    data['mainItem'] = this.mainItem != null ? this.mainItem.toJson() : null;
    data['item1'] = this.item1 != null ? this.item1.toJson() : null;
    data['item2'] = this.item2 != null ? this.item2.toJson() : null;
    data['item3'] = this.item3 != null ? this.item3.toJson() : null;
    data['item4'] = this.item4 != null ? this.item4.toJson() : null;
    return data;
  }

}