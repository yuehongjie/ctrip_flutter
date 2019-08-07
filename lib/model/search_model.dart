
/// 搜索 Model
class SearchModel {

  final List<SearchItem> data;
  String keyword;

  SearchModel({this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
     if (json == null) return null;

     var dataJson = json['data'] as List;
     List<SearchItem> data = dataJson.map((i) => SearchItem.fromJson(i)).toList();

     return SearchModel(data: data);
  }

}

/* 搜索的 item
* "word": "北京二十一世纪饭店",
  "type": "hotel",
  "price": "实时计价",
  "star": "三星级",
  "zonename": "燕莎/三里屯 ",
  "districtname": "北京",
  "url": "http://m.ctrip.com/webapp/hotel/hoteldetail/608377.html?atime=20190807"
* */
class SearchItem {

  final String word;
  final String type;
  final String price;
  final String star;
  final String zonename;
  final String districtname;
  final String url;

  SearchItem({this.word, this.type, this.price, this.star, this.zonename, this.districtname, this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return json == null ? null :
        SearchItem(
          word: json['word'],
          type: json['type'],
          price: json['price'],
          star: json['star'],
          zonename: json['zonename'],
          districtname: json['districtname'],
          url: json['url'],
        );

  }

}