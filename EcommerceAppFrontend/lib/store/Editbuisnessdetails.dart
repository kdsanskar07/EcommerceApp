import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/selectcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';



bool calling = false;

class EditBuisnessDetails extends StatefulWidget {
  StoreInfo storeInfo;
  UserInfo userInfo;
  EditBuisnessDetails({this.storeInfo,this.userInfo});
  @override
  _EditBuisnessDetailsState createState() => _EditBuisnessDetailsState();
}

class _EditBuisnessDetailsState extends State<EditBuisnessDetails> {

  Future<void> updateStore() async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: widget.storeInfo,
        context: context,
        url: 'http://10.0.2.2:3000/store/update'
    );
    var response = await request.getRequest();
    print(response);
  }

// String getCategory(List<int> category){
//   String s="";
//   for(int i=0;i<category.length&&i<2;i++){
//     if(category[i] == )
//     s+="/ ";
//   }
//   return s;
// }

File _image;
FileImage newImage;
Future getImage() async {
   _image = calling
      // ignore: deprecated_member_use
      ? await ImagePicker.pickImage(source:ImageSource.gallery)
      // ignore: deprecated_member_use
      : await ImagePicker.pickImage(source:ImageSource.camera);
  setState(() {
    if (_image != null) {
      newImage = FileImage(_image);
    } else {
      print('No image selected.');
    }
  });
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
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Profile",style: TextStyle(
          color: Colors.black87,
        ),),
        elevation: 0,
        leading: InkWell(onTap: (){
          Navigator.of(context).pop();
        },child: Icon(Icons.arrow_back,color: Colors.black87,)),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: Container(
        height: _height*0.1,
        width: _width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
          ),
        ),
        child: Center(
          child: Container(
            height: _height*0.07,
            width: _width,
            margin: EdgeInsets.fromLTRB(_width*0.04, 0,_width*0.04, 0),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: InkWell(
              onTap: (){
               updateStore();
                Navigator.pop(context);
              },
              child: Center(
                child: AutoSizeText("Save",style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
                maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                width: _width*0.4,
                height: _height*0.04,
                margin: EdgeInsets.fromLTRB(_width*0.06, _height*0.01, _width*0.06, 0),
                child: AutoSizeText("Cover Photo",style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
                  maxLines: 1,
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
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
                        child: widget.storeInfo.img==""?null:Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.storeInfo.img),
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
              SizedBox(height: _height*0.03,),
              Container(
                margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                padding: EdgeInsets.fromLTRB(0,_height*0.015,_width*0.03,0),
                height: _height*0.1,
                decoration: BoxDecoration(
                  // color: Colors.red,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[400],width: 1),
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: _height*0.045,
                      width: _width*0.32,
                      child: AutoSizeText("Store Name",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: _height*0.015,),
                    Container(
                      height: _height*0.02,
                      child: TextFormField(
                        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                        style: TextStyle(
                          fontSize: 20,
                          // color: Colors.teal,
                        ),
                        maxLength: 30,
                        initialValue: widget.storeInfo.name,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          // contentPadding: EdgeInsets.fromLTRB(_width*0.01,),
                        ),

                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: _height*0.03,),
              Container(
                margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                padding: EdgeInsets.fromLTRB(0,_height*0.015,_width*0.03,0),
                height: _height*0.1,
                decoration: BoxDecoration(
                  // color: Colors.red,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[400],width: 1),
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // color: Colors.blue,
                      height: _height*0.045,
                      width: _width*0.6,
                      child: AutoSizeText("Store Mobile Number",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: _height*0.015,),
                    Container(
                      height: _height*0.02,
                      child: TextFormField(
                        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                        style: TextStyle(
                          fontSize: 20,
                          // color: Colors.teal,
                        ),
                        maxLength: 30,
                        initialValue: widget.storeInfo.mob,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          // contentPadding: EdgeInsets.fromLTRB(_width*0.01,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: _height*0.04,),
              InkWell(
                onTap: (){
                  debugPrint("Buisness Category");
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => SelectCategory())
                  );
                },
                child: Container(
                  height: _height*0.1,
                  margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          spreadRadius: 0.3,
                          offset: Offset(1,1),
                          blurRadius: 0.5,
                        ),
                      ],
                      border: Border.all(
                          color: Colors.teal, width: 1)),
                  padding: EdgeInsets.fromLTRB(_width*0.04,_width*0.03,_width*0.04,_width*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width*0.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: _height*0.03,
                              width: _width*0.5,
                              // color: Colors.red,
                              child: AutoSizeText("Buisness Category",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              ),
                            ),
                            SizedBox(height: _height*0.01,),
                            Container(
                              // color: Colors.red,
                                height: _height*0.028,
                                child: AutoSizeText(
                                'Category',maxLines: 1,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: _width*0.1,),
                      Icon(Icons.arrow_forward_ios,size: 16,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
