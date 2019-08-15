
/// 旅拍 Tab 标签模型
class TravelTabModel {
  String url;
  Params params;
  List<TabItem> tabs;

  TravelTabModel({this.url, this.params, this.tabs});

  TravelTabModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    params =
    json['params'] != null ? new Params.fromJson(json['params']) : null;
    if (json['tabs'] != null) {
      tabs = new List<TabItem>();
      json['tabs'].forEach((v) {
        tabs.add(new TabItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    if (this.tabs != null) {
      data['tabs'] = this.tabs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Params {
  String groupChannelCode;
  PagePara pagePara;

  Params({this.groupChannelCode, this.pagePara});

  Params.fromJson(Map<String, dynamic> json) {
    groupChannelCode = json['groupChannelCode'];
    pagePara = json['pagePara'] != null
        ? new PagePara.fromJson(json['pagePara'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupChannelCode'] = this.groupChannelCode;
    if (this.pagePara != null) {
      data['pagePara'] = this.pagePara.toJson();
    }
    return data;
  }
}

class PagePara {
  int pageIndex;
  int pageSize;

  PagePara({this.pageIndex, this.pageSize});

  PagePara.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    return data;
  }
}

class TabItem {
  String labelName;
  String groupChannelCode;

  TabItem({this.labelName, this.groupChannelCode});

  TabItem.fromJson(Map<String, dynamic> json) {
    labelName = json['labelName'];
    groupChannelCode = json['groupChannelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelName'] = this.labelName;
    data['groupChannelCode'] = this.groupChannelCode;
    return data;
  }
}
