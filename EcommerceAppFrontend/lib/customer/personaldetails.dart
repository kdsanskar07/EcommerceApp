import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/customer/homepage.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/others/saveImage.dart';
import 'package:e_commerce/others/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

bool calling = false;

class DetailsPage extends StatefulWidget {
  UserInfo userInfo;
  DetailsPage({this.userInfo});
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String name;
  String mob;
  bool first=true;
  bool isPressedSave= false;
  final _textName = TextEditingController();
  bool _validateName = false;
  final _textMob = TextEditingController();
  bool _validateMob = false;


  Future<void> getUserDetail() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/users/getuserdetail'
    );
    var response = await request.getRequest();
    widget.userInfo = new UserInfo(
      email: response['data']['email'],
      buildingNumber: response['data']['buildingNumber'],
      name: response['data']['name'],
      dob: response['data']['dob'],
      mob: response['data']['mob'],
      gender: response['data']['gender'],
      pic : response['data']['pic'],
      type: response['data']['type'],
      streetName: response['data']['streetName'],
      city: response['data']['city'],
      locality: response['data']['locality'],
      pinCode: response['data']['pinCode'],
    );
  }

  File newImage;
  Future getImage() async {
    newImage = calling
    // ignore: deprecated_member_use
        ? await ImagePicker.pickImage(source:ImageSource.gallery)
    // ignore: deprecated_member_use
        : await ImagePicker.pickImage(source:ImageSource.camera);
    if (newImage != null) {
      print('type'+newImage.runtimeType.toString());
      String path = widget.userInfo.email+'/profilepic';
      String newImageUrl= await uploadImage(newImage,path);
      if(newImageUrl==null){
        widget.userInfo.pic="";
        showFlushBar(true,"Image did not uploded! Try again.",context);
      }else {
        setState(() {
          widget.userInfo.pic=newImageUrl;
        });
      }
    } else {
      print('No image selected.');
    }
  }

  void sendUserDetails() async {
    print('email'+widget.userInfo.email);
    Requests requests = new Requests(
      url: 'http://10.0.2.2:3000/users/updateuserdetail',
      isHeader: true,
      context: context,
      bodyData: widget.userInfo.getUser(),
    );
    var response = await requests.postRequest();
    await getUserDetail();
    isPressedSave=false;
    if(response!=null){
      Navigator.push(
          context, CupertinoPageRoute(
        builder: (context) => HomePage(userInfo: widget.userInfo,),
      )
      );
    }
  }

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
                            fontWeight: FontWeight.bold
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
                            fontWeight: FontWeight.bold
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
    if(first==true){
      first=false;
      _textMob.text = widget.userInfo.mob;
      _textName.text = widget.userInfo.name;
    }
    final _height=MediaQuery.of(context).size.height;
    final _width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text("Set Profile",style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),),
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          setState(() {
            _textMob.text.length!=10 ? _validateMob = true : _validateMob = false;
            _textName.text.isEmpty ? _validateName = true : _validateName = false;
          });

          if(_textMob.text.length==10 && _textName.text.isEmpty==false){
            widget.userInfo.name = _textName.text;
            widget.userInfo.mob = _textMob.text;
          if(isPressedSave==false){
            isPressedSave=true;
            sendUserDetails();
          }
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, _height*0.01),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.teal,
          ),
          height: _height*0.07,
          width: _width,
          child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 24,
                ),
              )
          ),
        ),
      ),
      body: Container(
        height: _height*0.8,
        child: ListView(
          children: <Widget>[
            Container(
              height: _height*0.2,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: _height*.02,
                    left: (_width-_height*.16)*0.5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                            color: Colors.teal,
                            width: 2,
                          )
                      ),
                      height: _height*.16,
                      width: _width*.3,
                      child: widget.userInfo.pic==""?Icon(Icons.person,size: _height*0.14,color: Colors.white,):Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.userInfo.pic),
                      ),
                    ),
                  ),
                  Positioned(
                    top: _height*.15,
                    left: _width*0.585,
                    child: InkWell(
                        onTap: (){
                          bottomSheet(context);
                        },
                        child: Icon(Icons.camera_alt)
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06, 0, 0, 0),
              height: _height*0.034,
              width: _width*0.2,
              child: AutoSizeText("Name",style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
                maxLines: 1,
              ),
            ),
            SizedBox(height: _height*0.02,),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
              height: _height*0.05,
              child: TextField(
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                style: TextStyle(
                  fontSize: 20,
                ),
                maxLength: 30,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                controller: _textName,
                decoration: new InputDecoration(
                  errorMaxLines: 1,
                  errorText: _validateName?"Name Should be between 1-30.":null,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: _height*0.03,),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
              height: _height*0.11,
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[400],width: 1.5),
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: _height*0.034,
                    width: _width*0.25,
                    child: AutoSizeText("Email",style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: _height*0.03,),
                  Container(
                    height: _height*0.04,
                    child:AutoSizeText(widget.userInfo.email,style: TextStyle(
                      fontSize: 20,
                    ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: _height*0.03,),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.fromLTRB(_width*0.06, 0, 0, 0),
              height: _height*0.034,
              width: _width*0.4,
              child: AutoSizeText("Mobile Number",style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
                maxLines: 1,
              ),
            ),
            SizedBox(height: _height*0.02,),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
              height: _height*0.05,
              child: TextField(
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                style: TextStyle(
                  fontSize: 20,
                ),
                maxLength: 10,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                controller: _textMob,
                decoration: new InputDecoration(
                  errorMaxLines: 1,
                  errorText: _validateMob?"Enter valid Mobile Number.":null,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[500],width: 1)),
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: _height*0.01,),
            InkWell(
              onTap: (){
                Future<DateTime> newDateTime = showRoundedDatePicker(
                  context: context,
                  height: _height*0.45,
                  theme: ThemeData(
                    primaryColor: Colors.teal,
                    accentColor: Colors.teal,
                  ),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 50),
                  lastDate: DateTime(DateTime.now().year + 1),
                  borderRadius: 16,
                );
                int day, month, year;
                String temp="";
                newDateTime.then((value) => {
                  if(value!=null){
                    day = value.day,
                    month = value.month,
                    year = value.year,
                    temp = temp + day.toString() + " ",
                    if(month==1){
                      temp = temp + "	January ",
                    },
                    if(month==2){
                      temp = temp + "February ",
                    },
                    if(month==3){
                      temp = temp + "March ",
                    },
                    if(month==4){
                      temp = temp + "April ",
                    },
                    if(month==5){
                      temp = temp + "May ",
                    },
                    if(month==6){
                      temp = temp + "June ",
                    },
                    if(month==7){
                      temp = temp + "July ",
                    },
                    if(month==8){
                      temp = temp + "August ",
                    },
                    if(month==9){
                      temp = temp + "September ",
                    },
                    if(month==10){
                      temp = temp + "October ",
                    },
                    if(month==11){
                      temp = temp + "November ",
                    },
                    if(month==12){
                      temp = temp + "December ",
                    },
                    temp = temp + year.toString(),
                    setState(() {
                      widget.userInfo.dob = temp;
                    }),
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                padding: EdgeInsets.fromLTRB(0,_height*0.015,_width*0.0,0),
                height: _height*0.1,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[500],width: 1),
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: _height*0.034,
                      width: _width*0.4,
                      child: AutoSizeText("Birthday",style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: _height*0.01,),
                    Row(
                      children: <Widget>[
                        Container(
                          // color: Colors.red,
                          height: _height*0.034,
                          width: _width*0.6,
                          child: AutoSizeText(
                            widget.userInfo.dob,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(width: _width*0.23,),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: _height*0.03,),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
              height: _height*0.07,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87,width: 1.5)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: (){
                        debugPrint("Update gender to male");
                        setState(() {
                          widget.userInfo.gender="male";
                        });
                      },
                      child: Container(
                        height: _height*0.07,
                        child: Center(
                          child: widget.userInfo.gender=="male"?Row(
                            children: <Widget>[
                              SizedBox(width: _width*0.07,),
                              Icon(Icons.check,color: Colors.teal,),
                              SizedBox(width: _width*0.02,),
                              Container(
                                height: _height*0.033,
                                width: _width*0.12,
                                child: AutoSizeText("Male",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ):Container(
                            height: _height*0.033,
                            width: _width*0.12,
                            child: AutoSizeText("Male",style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 2,color: Colors.grey[400]),
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: (){
                        debugPrint("Update gender to female");
                        setState(() {
                          widget.userInfo.gender="female";
                        });
                      },
                      child: Container(
                        height: _height*0.07,
                        child: Center(
                          child: widget.userInfo.gender=="female"?Row(
                            children: <Widget>[
                              SizedBox(width: _width*0.07,),
                              Icon(Icons.check,color: Colors.teal,),
                              SizedBox(width: _width*0.02,),
                              Container(
                                height: _height*0.033,
                                width: _width*0.2,
                                child: AutoSizeText("Female",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ):Container(
                            height: _height*0.033,
                            width: _width*0.2,
                            child: AutoSizeText("Female",style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _height*0.02,),
            Container(
              height: _height*0.07,
              margin: EdgeInsets.fromLTRB(_width*.05, 0, _width*.05, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal,width: 2),
              ),
              child: FlatButton(
                color: Colors.white,
                textColor: Colors.teal,
                onPressed: (){debugPrint("Change password");},
                child: AutoSizeText("Change Password",style: TextStyle(
                  fontSize: 22,
                ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
