import 'dart:convert';
import 'package:e_commerce/others/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Requests{
  var bodyData;
  bool isHeader;
  String bearerToken;
  var url;
  BuildContext context;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Requests({this.bodyData,this.isHeader,this.url,this.context});

  Future<String> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map> postRequest() async {
    bearerToken = await getToken();
    bodyData=json.encode(bodyData);
    print(bodyData);
    final http.Response response = await http.post(
      url,
      headers: isHeader==true?{'Authorization': bearerToken,"content-type":"application/json"}:{"content-type":"application/json"},
      body: bodyData,
    );
    print("res: "+response.statusCode.toString());
    var data = json.decode(response.body);
    if(response.statusCode==200|| response.statusCode==201){
      if(data['msg']!=null){
        showFlushBar(data['success'],data['msg'],context);
        return Future.delayed(Duration(seconds: 3), ()=>data);
      }else{
        return data;
      }
    }else{
      showFlushBar(data['success'],data['msg'],context);
      return null;
    }
  }


  Future<Map> getRequest() async {
    bearerToken = await getToken();
    // bodyData=json.encode(bodyData);
    print(bearerToken);
    final http.Response response = await http.get(
      url,
      headers: isHeader==true?{'Authorization': bearerToken,}:{"content-type":"application/json"},
    );
    var data = json.decode(response.body);
    print("data"+data.toString());
    if(response.statusCode==200|| response.statusCode==201){
      if(data['msg']!=null){
        showFlushBar(data['success'],data['msg'],context);
        return Future.delayed(Duration(seconds: 3), ()=>data);
      }else{
        return data;
      }
    }else{
      showFlushBar(data['success'],data['msg'],context);
      return null;
    }
  }

}