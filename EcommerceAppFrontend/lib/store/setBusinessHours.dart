import 'package:date_time_picker/date_time_picker.dart';
import 'package:e_commerce/class/store.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/account.dart';
import 'package:e_commerce/store/newcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';

class SetStoreOpenDays extends StatefulWidget {
  UserInfo userInfo;
  StoreInfo storeInfo;
  SetStoreOpenDays({this.storeInfo,this.userInfo});
  @override
  _SetStoreOpenDaysState createState() => _SetStoreOpenDaysState();
}

class _SetStoreOpenDaysState extends State<SetStoreOpenDays> {
  bool isPressedDone = false;
  bool isFirst= true;

  TextEditingController _storeOpensAt = new TextEditingController();
  TextEditingController _storeClosesAt = new TextEditingController();
  bool _validateStoreOpensAt =true;
  bool _validateStoreClosesAt =true;

  void updateStore() async {
    Requests requests = new Requests(
      url: 'http://10.0.2.2:3000/store/update',
      isHeader: true,
      context: context,
      bodyData: widget.storeInfo.getStore(),
    );
    var response = await requests.postRequest();
    isPressedDone=false;
    if(response!=null){
      Navigator.push(
          context, CupertinoPageRoute(
        builder: (context) => Account(userInfo : widget.userInfo,storeInfo: widget.storeInfo),
      )
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.height;
    if(isFirst==true){
      isFirst=false;
      _storeOpensAt.text = widget.storeInfo.openingTime;
      _storeClosesAt.text = widget.storeInfo.closingTime;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: (){
          setState(() {
            _storeOpensAt.text.isEmpty ? _validateStoreOpensAt = false : _validateStoreOpensAt =true;
            _storeClosesAt.text.isEmpty ? _validateStoreClosesAt =false : _validateStoreClosesAt =true;
          });
          if(!_storeClosesAt.text.isEmpty && !_storeOpensAt.text.isEmpty){
            widget.storeInfo.openingTime = _storeOpensAt.text;
            widget.storeInfo.closingTime = _storeClosesAt.text;
            // print(widget.storeInfo.closingTime);
            // print(widget.storeInfo.openingTime);
            // print(widget.storeInfo.isOpenOnSunday);
            // print(widget.storeInfo.isOpenOnSaturday);
            // print(widget.storeInfo.isOpenOnFriday);
            // print("th: "+widget.storeInfo.isOpenOnThursday.toString());
            // print(widget.storeInfo.isOpenOnWednesday);
            // print(widget.storeInfo.isOpenOnTuesday);
            // print(widget.storeInfo.isOpenOnMonday);
          }
          updateStore();
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(_width*0.02, _height*0.01, _width*0.02, _height*0.02),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: _height*0.07,
          child: Center(
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Business Hours',
          style: TextStyle(color: Colors.black ,fontSize: 24, fontWeight: FontWeight.w400),
        ),
        //centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {Navigator.of(context).pop();},
        ),
      ),
      body:
      ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            height: _height*0.05,
            child: Text(
              'Store Opens At ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04,0, MediaQuery.of(context).size.width * .04, 0),
            height: _height*0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(color: Colors.teal,width: 1)
            ),
            child:   DateTimePicker(
              type: DateTimePickerType.time,
              controller: _storeOpensAt,
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20
              ),
              use24HourFormat: false,
              cursorColor: Colors.teal,
              icon: Icon(Icons.access_time,color: Colors.teal,),
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: widget.storeInfo.openingTime,
                  errorMaxLines: 1,
                  errorText: _validateStoreOpensAt==false?"Enter valid Store Opening time.":null,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
              locale: Locale('en', 'US'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            height: _height*0.05,
            child: Text(
              'Store Closes At ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04,0, MediaQuery.of(context).size.width * .04, 0),
            height: _height*0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(color: Colors.teal,width: 1)
            ),
            child:   DateTimePicker(
              type: DateTimePickerType.time,
              controller: _storeClosesAt,
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20
              ),
              use24HourFormat: false,
              cursorColor: Colors.teal,
              icon: Icon(Icons.access_time,color: Colors.teal,),
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: widget.storeInfo.closingTime,
                  errorText: _validateStoreClosesAt==false?"Enter valid Store Closing time.":null,
                  errorMaxLines: 1,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(_width*0.01)
              ),
              locale: Locale('en', 'US'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            height: _height*0.05,

            child: Text(
              'Store Working Days ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'M',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Monday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnMonday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnMonday==0?widget.storeInfo.isOpenOnMonday=1:widget.storeInfo.isOpenOnMonday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'T',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Tuesday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnTuesday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnTuesday==0?widget.storeInfo.isOpenOnTuesday=1:widget.storeInfo.isOpenOnTuesday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'W',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Wednessday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnWednesday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnWednesday ==0?widget.storeInfo.isOpenOnWednesday=1:widget.storeInfo.isOpenOnWednesday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'T',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Thursday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnThursday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnThursday ==0?widget.storeInfo.isOpenOnThursday=1:widget.storeInfo.isOpenOnThursday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'F',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Friday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnFriday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnFriday==0?widget.storeInfo.isOpenOnFriday=1:widget.storeInfo.isOpenOnFriday=00;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'S',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Saturday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnSaturday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnSaturday ==0?widget.storeInfo.isOpenOnSaturday=1:widget.storeInfo.isOpenOnSaturday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal,width: 1)
            ),
            height: _height*0.1,
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .04, MediaQuery.of(context).size.height * .02, MediaQuery.of(context).size.width * .04, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal,
                  child: Text(
                    'S',
                    style: TextStyle(color: Colors.white , fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .22,
                ),
                Container(
                  height: _height * 0.035,
                  width: _width * 0.17,
                  child: AutoSizeText(
                    'Sunday',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: _width*0.03,),
                Switch(
                  hoverColor: Colors.black,
                  value: widget.storeInfo.isOpenOnSunday==0?false:true,
                  onChanged: (value) {
                    setState(() {
                      widget.storeInfo.isOpenOnSunday==0 ? widget.storeInfo.isOpenOnSunday=1:widget.storeInfo.isOpenOnSunday=0;
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ],
            ),
          ),
          SizedBox(height: _height*0.1,)
        ],
      ),
    );
  }
}
