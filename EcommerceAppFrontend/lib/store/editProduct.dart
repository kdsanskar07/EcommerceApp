import 'dart:io';
import 'package:e_commerce/class/category.dart';
import 'package:e_commerce/class/productinfo.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/others/saveImage.dart';
import 'package:e_commerce/others/snackbar.dart';
import 'package:e_commerce/store/shopproducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

bool calling = false;

class EditProduct extends StatefulWidget {
  int categoryListIndex;
  ProductInfo data ;
  List<CategoryInfo> categoryList;
  UserInfo userInfo ;
  EditProduct({this.categoryListIndex,this.userInfo,this.categoryList,this.data});
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String _value = 'per unit';
  bool isPressed = false;
  int _categories = 0;

  File newImage;
  Future getImage() async {
    newImage = calling
    // ignore: deprecated_member_use
        ? await ImagePicker.pickImage(source:ImageSource.gallery)
    // ignore: deprecated_member_use
        : await ImagePicker.pickImage(source:ImageSource.camera);
    if (newImage != null) {
      print('type'+newImage.runtimeType.toString());
      String path = widget.userInfo.email+'/'+DateTime.now().toString();
      String newImageUrl= await uploadImage(newImage,path);
      print("new:: "+newImageUrl.toString());
      if(newImageUrl==null){
        widget.data.img="";
        showFlushBar(false,"Image did not uploaded! Try again.",context);
      }else {
        setState(() {
          widget.data.img=newImageUrl;
          showFlushBar(true,"Image Uploaded Successfully",context);
        });
      }
    } else {
      showFlushBar(false,"Image did not uploaded! Try again.",context);
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

  List<DropdownMenuItem> getDropdownList(){
    List<DropdownMenuItem> data= [];
    for(var i = 0; i<widget.categoryList.length;i++){
      DropdownMenuItem temp = DropdownMenuItem(
        child: Container(
          child: AutoSizeText(
            widget.categoryList[i].name,
            style:
            TextStyle(fontSize: 18, color: Colors.black54),
            maxLines: 1,
          ),
        ),
        value: i,
      );
      data.add(temp);
    }
    return data;
  }

  void sendProductDetails() async {
    Requests requests = new Requests(
      url: 'http://10.0.2.2:3000/product/updateproduct',
      isHeader: true,
      context: context,
      bodyData: widget.data.getProduct(),
    );
    var response = await requests.postRequest();
    isPressed=false;
    print("res::: "+response.toString());
    if(response['success']==true){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          child: AutoSizeText(
            'Edit Product',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400 , color: Colors.black),
            maxLines: 1,
          ),
        ),
        centerTitle: false,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, CupertinoPageRoute(
              builder: (context) => ShopProducts(categoryListIndex:widget.categoryListIndex,userInfo:widget.userInfo,categoryList: widget.categoryList,),
            )
            );
          },
        ),
      ),
      bottomNavigationBar: InkWell(
        child: Container(
          margin: EdgeInsets.fromLTRB(
              _width * 0.04, 0, _width * 0.04, _height*0.02),
          height: _height * 0.07,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.teal,
          ),
          child: Center(
            child: Container(
              child: AutoSizeText(
                'Submit',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
        onTap: () {
          if(isPressed==false){
            isPressed=true;
            print(widget.data.price);
            print(widget.data.name);
            print(widget.data.description);
            print(widget.data.unit);
            print(widget.data.totalQuantity);
            print(widget.data.img);
            widget.data.categoryId= widget.categoryListIndex;
            print(widget.data.categoryId);
            sendProductDetails();
          }
        },
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: widget.data.name,
                  hintStyle:
                  TextStyle(color: Colors.black54, fontSize: 18),
                  border: InputBorder.none),
              onChanged: (value){
                setState(() {
                  widget.data.name = value;
                });
              },
              validator: (value){
                if(value.isEmpty){
                  print('Please enter some text');
                  return ;
                }
                widget.data.name = value;
                return ;
              },
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .5,
                margin: EdgeInsets.fromLTRB(_width * 0.05, 0, _width * 0.05, 0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.teal)),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: widget.data.price,
                      hintStyle:
                      TextStyle(color: Colors.black54, fontSize: 18),
                      border: InputBorder.none),
                  onChanged: (value){
                    setState(() {
                      widget.data.price = value;
                    });
                  },
                  validator: (value){
                    if(value.isEmpty){
                      print('Please enter some text');
                      return ;
                    }
                    widget.data.price = value;
                    return ;
                  },
                ),
              ),
              SizedBox(
                width: _width * 0.05,
              ),
              Container(
                // height: MediaQuery.of(context).size.height * .12,
                width: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.teal)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Container(
                          child: AutoSizeText(
                            'per unit',
                            style: TextStyle(
                                fontSize: 18, color: Colors.black54),
                            maxLines: 1,
                          ),
                        ),
                        value: "per unit",
                      ),
                      DropdownMenuItem(
                        child: AutoSizeText(
                          'per kg',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black54),
                          maxLines: 1,
                        ),
                        value: "per kg",
                      ),
                      DropdownMenuItem(
                        child: AutoSizeText(
                          'per gm',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black54),
                          maxLines: 1,
                        ),
                        value: "per gm",
                      ),
                      DropdownMenuItem(
                        child: AutoSizeText(
                          'per ltr',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black54),
                          maxLines: 1,
                        ),
                        value: "per ltr",
                      ),
                      DropdownMenuItem(
                        child: AutoSizeText(
                          'per ml',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black54),
                          maxLines: 1,
                        ),
                        value: "per ml",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin:
            EdgeInsets.fromLTRB(_width * 0.05, _height * 0.009, _width * 0.05, 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: widget.data.description,
                  hintStyle:
                  TextStyle(color: Colors.black54, fontSize: 18),
                  border: InputBorder.none),
              onChanged: (value){
                setState(() {
                  widget.data.description = value;
                });
              },
              validator: (value){
                if(value.isEmpty){
                  print('Please enter some text');
                  return ;
                }
                widget.data.description = value;
                return ;
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(_width * 0.05, _height * 0.009, _width * 0.05, 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _categories,
                items: getDropdownList(),
                onChanged: (value) {
                  setState(() {
                    _categories = value;
                  });
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                _width * 0.04, _height * 0.1, _width * 0.04, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal , width: 1)
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: _height * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: AutoSizeText(
                      'Add Product Image',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.04,
                          vertical: _height * 0.02),
                      height: _height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                      ),
                      child: Center(
                        child: Text(
                          'Add Image',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // getImage();
                      bottomSheet(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
