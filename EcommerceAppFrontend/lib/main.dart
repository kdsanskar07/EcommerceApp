import 'dart:convert';
import 'package:e_commerce/authentication/login.dart';
import 'package:e_commerce/authentication/register.dart';
import 'package:e_commerce/authentication/setuserdetails.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/customer/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<UserInfo> getUserDetail(token) async {
  final http.Response response = await http.get(
    'http://10.0.2.2:3000/users/getuserdetail',
    headers: {'Authorization': token,},
  );
  var res = json.decode(response.body);

  UserInfo userInfo = new UserInfo(
    email: res['data']['email'],
    buildingNumber: res['data']['buildingNumber'],
    name: res['data']['name'],
    dob: res['data']['dob'],
    mob: res['data']['mob'],
    gender: res['data']['gender'],
    pic : res['data']['pic'],
    type: res['data']['type'],
    streetName: res['data']['streetName'],
    city: res['data']['city'],
    locality: res['data']['locality'],
    pinCode: res['data']['pinCode'],
  );
  return userInfo;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String token = await storage.read(key: 'token');
  UserInfo userInfo;
  int pageValue=0;
  if(token!=null){
    userInfo = await getUserDetail(token);
    if(userInfo.pinCode==""){
      pageValue=2;
    }else{
      pageValue=1;
    }
  }
  runApp(
      MaterialApp(
        routes: {
          '/homepage': (context) => HomePage(userInfo: userInfo,),
          '/registerpage': (context) => RegisterPage(),
        },
        debugShowCheckedModeBanner: false,
        home: pageValue==0?LoginPage():pageValue==1?HomePage(userInfo: userInfo,):SetUserDetails(userInfo: userInfo,),
      )
  );
}
