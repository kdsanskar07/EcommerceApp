import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/store/AddStoreOpenDays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AddAddress extends StatefulWidget {
  UserInfo userInfo;
  StoreInfo storeInfo;
  AddAddress({this.userInfo,this.storeInfo});
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool isFirst= true;

  final _textBuildingNumber = TextEditingController();
  bool _validateBuildingNumber = true;
  final _textStreetName = TextEditingController();
  bool _validateStreetName = true;
  final _textLocality = TextEditingController();
  bool _validateLocality = true;
  final _textCity = TextEditingController();
  bool _validateCity = true;
  final _textPinCode = TextEditingController();
  bool _validatePinCode = true;

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    if(isFirst==true){
      isFirst=false;
      _textStreetName.text = widget.storeInfo.streetName;
      _textLocality.text = widget.storeInfo.locality;
      _textBuildingNumber.text = widget.storeInfo.buildingNumber;
      _textPinCode.text = widget.storeInfo.pinCode;
      _textCity.text = widget.storeInfo.city;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          child: AutoSizeText(
            'Add Address',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400 , color: Colors.black),
            maxLines: 1,
          ),

        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {Navigator.of(context).pop();},
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 6,
              cursorColor: Colors.teal,
              keyboardType: TextInputType.number,
              autofocus: false,
              controller: _textBuildingNumber,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  hintText: 'Building Number',
                  errorText: !_validateBuildingNumber?"Enter valid Building Number.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 6,
              cursorColor: Colors.teal,
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _textStreetName,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  hintText: 'Street Name',
                  errorText: !_validateStreetName?"Enter valid Street Name.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 6,
              cursorColor: Colors.teal,
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _textLocality,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  hintText: 'Locality',
                  errorText: !_validateLocality?"Enter valid Locality.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 6,
              cursorColor: Colors.teal,
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _textCity,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  hintText: 'City',
                  errorText: !_validateCity?"Enter valid City.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(_width * 0.04, 0, _width * 0.04, 0),
            decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(color: Colors.teal)),
            ),
            child: TextField(
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              style: TextStyle(
                fontSize: 20,
              ),
              maxLength: 6,
              cursorColor: Colors.teal,
              keyboardType: TextInputType.number,
              autofocus: false,
              controller: _textPinCode,
              decoration: new InputDecoration(
                  errorMaxLines: 1,
                  hintText: 'Pin Code',
                  errorText: !_validatePinCode?"Enter valid Pin Code.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: InkWell(
          onTap: () {
            setState(() {
              _textPinCode.text.length!=6 ? _validatePinCode=false : _validatePinCode=true;
              _textLocality.text.isEmpty ? _validateLocality=false : _validateLocality=true;
              _textStreetName.text.isEmpty ? _validateStreetName=false : _validateStreetName=true;
              _textBuildingNumber.text.isEmpty ? _validateBuildingNumber=false : _validateBuildingNumber=true;
              _textCity.text.isEmpty ? _validateCity=false : _validateCity=true;
            });
            if(_textCity.text.isEmpty==false&&_textBuildingNumber.text.isEmpty==false&&_textStreetName.text.isEmpty==false&&_textLocality.text.isEmpty==false&&_textPinCode.text.length==6){
              widget.storeInfo.city = _textCity.text;
              widget.storeInfo.streetName = _textStreetName.text;
              widget.storeInfo.locality = _textLocality.text;
              widget.storeInfo.buildingNumber = _textBuildingNumber.text;
              widget.storeInfo.pinCode = _textPinCode.text;
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => AddStoreOpenDays(storeInfo: widget.storeInfo,userInfo: widget.userInfo))
                );
            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(_width*0.04, _height*0.01, _width*0.04, _height*0.02),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            height: _height*0.07,
            child: Row(
              children: <Widget>[
                SizedBox(width: _width*0.05,),
                Text(
                  'Set Store Timings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: _width*0.37,),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          )
      ),
    );
  }
}
