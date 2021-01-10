import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/saveImage.dart';
import 'package:e_commerce/others/snackbar.dart';
import 'package:e_commerce/store/addAddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
bool calling = false;

class Register extends StatefulWidget {
  UserInfo userInfo;
  Register({this.userInfo});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  StoreInfo storeInfo =new StoreInfo(
    streetName: "",pinCode: "",locality: "",city: "",buildingNumber: "",isOpenOnWednesday: 0,
    isOpenOnTuesday: 0,isOpenOnSunday: 0,isOpenOnThursday: 0,isOpenOnSaturday: 0,isOpenOnMonday: 0,
    isOpenOnFriday: 0, name: "",img: "",revenue: "",closingTime: "",isBookmark: 0,mob: "",noOfOrders: "",openingTime: "",
    rating: "",storeId: "",
  );
  File newImage;
  Future getImage() async {
    newImage = calling
    // ignore: deprecated_member_use
        ? await ImagePicker.pickImage(source:ImageSource.gallery)
    // ignore: deprecated_member_use
        : await ImagePicker.pickImage(source:ImageSource.camera);
    if (newImage != null) {
      String path = widget.userInfo.email+'/storepic';
      String newImageUrl= await uploadImage(newImage,path);
      print(newImageUrl);
      if(newImageUrl==null){
        storeInfo.img='';
        showFlushBar(true,"Image did not uploded! Try again.",context);
      }else {
        setState(() {
          storeInfo.img=newImageUrl;
        });
      }
    } else {
      print('No image selected.');
    }
  }

  final _textName = TextEditingController();

  bool _validateName = true;

  void bottomSheet(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: _height * .25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.white, offset: Offset(0, 10), blurRadius: 5.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: _height * .25,
                  width: _width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: 48.0,
                        icon: Icon(Icons.filter),
                        onPressed: () {
                          calling = true;
                          Navigator.of(context).pop();
                          getImage();
                          return;
                        },
                      ),
                      AutoSizeText(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 10),
                          blurRadius: 5.0),
                    ],
                  ),
                  height: _height * .25,
                  width: _width * .5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        iconSize: 48,
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          calling = false;
                          Navigator.of(context).pop();
                          getImage();
                          return;
                        },
                      ),
                      AutoSizeText(
                        "Camera",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          iconSize: 22,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Register',style: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: _height*0.025,
            margin: EdgeInsets.fromLTRB(_width*0.05, 0, 0, 0),
            child: Text("Cover Photo",style: TextStyle(
              fontSize: 20,
              color: Colors.indigo[900],
              fontWeight: FontWeight.w600,
            ),),
          ),
          SizedBox(height: _height*0.02,),
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin:EdgeInsets.fromLTRB(_width*0.05, _height*0.02, _width*0.05, 0),
                height: _height*.25,
                width: _width*0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: _width*0.91,
                    height: _height*0.23,
                    color: Colors.grey[100],
                    child: storeInfo.img==""?null:Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(storeInfo.img),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  bottomSheet(context);
                },
                child: Container(
                  width: _width*0.15,
                  height: _height*0.06,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.fromLTRB(_width*0.775, _height*0.19, 0, 0),
                  child: Icon(Icons.camera_alt),
                ),
              )
            ],
          ),
          SizedBox(height: _height*0.04,),
          Container(
            height: _height*0.025,
            margin: EdgeInsets.fromLTRB(_width*0.05, 0, 0, 0),
            child: Text("Store name",style: TextStyle(
              fontSize: 20,
              color: Colors.indigo[900],
              fontWeight: FontWeight.w600,
            ),),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.04, _height*0.01, _width*0.06, 0),
            height: _height*0.08,
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 15,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _textName,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  errorText: _validateName==false?"Enter valid Store name.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: _width*0.04,),
              Container(
                height: _height*0.05,
                width: _width*0.052,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent[700]
                ),
                child: Center(child: Text("1",style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),)),
              ),
              SizedBox(width: _width*0.025,),
              Container(
                height: _height*0.03,
                width: _width*0.16,
                // color: Colors.red,
                child: AutoSizeText("Register",style: TextStyle(
                  fontSize: 16,
                ),maxLines: 1,),
              ),
              SizedBox(width: _width*0.03,),
              Container(
                width: _width*0.12,
                height: 1.5,
                color: Colors.black,
              ),
              SizedBox(width: _width*0.03),
              Container(
                height: _height*0.05,
                width: _width*0.052,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellowAccent[700]
                ),
                child: Center(child: Text("2",style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),)),
              ),
              SizedBox(width: _width*0.025,),
              Container(
                height: _height*0.03,
                width: _width*0.25,
                // color: Colors.red,
                child: AutoSizeText("Add Products",style: TextStyle(
                  fontSize: 16,
                ),maxLines: 1,),
              ),
            ],
          ),
          SizedBox(height: _height*0.29),
          InkWell(
            onTap: (){
              setState(() {
                _textName.text.isEmpty? _validateName = false :_validateName =true ;
              });
              if(_textName.text.isEmpty==false){
                print(_textName.text);
                storeInfo.name = _textName.text;
                storeInfo.storeId = "";
                storeInfo.isOpenOnMonday=0;
                storeInfo.isOpenOnTuesday=0;
                storeInfo.isOpenOnWednesday=0;
                storeInfo.isOpenOnThursday=0;
                storeInfo.isOpenOnFriday=0;
                storeInfo.isOpenOnSaturday=0;
                storeInfo.isOpenOnSunday=0;
                storeInfo.noOfOrders = "0";
                storeInfo.revenue = "0";
                storeInfo.rating = "0";
                storeInfo.mob=widget.userInfo.mob;
                storeInfo.isBookmark = 0;
                storeInfo.categoryList=[];
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => AddAddress(storeInfo: storeInfo,userInfo: widget.userInfo,))
                );
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(_width*0.04, 0, _width*0.04, 0),
              height: _height*0.065,
              width: _width*0.9,
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text("Register",style: TextStyle(
                  fontSize: 22,
                  color: Colors.white
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }
}