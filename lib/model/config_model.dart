
/*

 "config": {
    "searchUrl": "https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=1"
  }

*/
class ConfigModel{
  final String searchUrl;

  ConfigModel({this.searchUrl});

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      searchUrl: json['searchUrl']
    );
  }

  Map<String, dynamic> toJson() {
    return {'searchUrl': searchUrl};
  }
}