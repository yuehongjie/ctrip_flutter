import 'package:ctrip_flutter/dao/travel_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TravelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TravelPageState();
  }

}

class _TravelPageState extends State<TravelPage> {

  String resultT='旅拍';

  @override
  void initState() {
    loadData();
    super.initState();
  }
  
  loadData() {
    
    TravelDao.fetch('tourphoto_global1', 1, 2).then((result){
      print(result);
      setState(() {
        resultT = result;
      });
    }).catchError((e) {
      print(e);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap:(){
          ClipboardData clipboardData = ClipboardData(text: resultT);
          Clipboard.setData(clipboardData);
        } ,
        child: Text(resultT),
      ),
    );
  }

}