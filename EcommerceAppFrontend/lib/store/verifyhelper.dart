import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/helper.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class VerifyHelper extends StatefulWidget {
  HelperInfo data;
  VerifyHelper({this.data});
  @override
  _VerifyHelperState createState() => _VerifyHelperState();
}

class _VerifyHelperState extends State<VerifyHelper> {
  bool isPressed=false;
  bool isPressedResendOtp = false;
  final _textOtp = TextEditingController();
  bool _validateOtp = true;

  void verifyHelper() async {
    Requests request = Requests(
        url: 'http://10.0.2.2:3000/helper/verify',
        context: context,
        isHeader: true,
        bodyData: {
          "otp": _textOtp.text,
          "email": widget.data.email,
        }
    );
    var response = await request.postRequest();
    isPressed=false;
    if(response!=null && response['success']==true){
      Navigator.push(
          context, CupertinoPageRoute(
        builder: (context) => Helper(),
      )
      );
    }
  }

  void resendOtp () async {
    Requests request = Requests(
      url: 'http://10.0.2.2:3000/helper/resendotp',
      context: context,
      isHeader: true,
      bodyData: {"email":widget.data.email},
    );
    await request.postRequest();
    isPressedResendOtp=false;
  }

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, "/registerpage", (r) => false);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        actions: <Widget>[
          InkWell(
            onTap: (){
              debugPrint("Show help page");
            },
            child: Container(
              width: _width*0.22,
              margin: EdgeInsets.fromLTRB(0, _height*0.03, _width*0.05, 1),
              child: AutoSizeText("Need Help?",style: TextStyle(
                color: Colors.teal,
                fontSize: 16,
              ),),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: _height*0.07,
                width: _width*0.82,
                margin: EdgeInsets.fromLTRB(_width*0.06, _height*0.03, _width*0.06, _height*0.02),
                child: AutoSizeText("Verify Helper", style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                ),
                  maxLines: 1,
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06,0, _width*0.06, _height*0.02),
              width: _width*0.9,
              child: AutoSizeText("Enter OTP sent to "+ widget.data.email,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 15,
                  color: Colors.black54,
                ),
                maxLines: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.07, _height*0.05, _width*0.06, 0),
              width: _width*0.8,
              height: _height*0.03,
              child: AutoSizeText("One Time Password(OTP)",style: TextStyle(
                fontSize: 17,
                color: Colors.teal,
                fontWeight: FontWeight.w400,
              ),
                maxLines: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06, _height*0.01, _width*0.06, 0),
              height: _height*0.08,
              child: TextField(
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                style: TextStyle(
                  fontSize: 20,
                ),
                maxLength: 6,
                cursorColor: Colors.teal,
                keyboardType: TextInputType.number,
                autofocus: false,
                controller: _textOtp,
                decoration: new InputDecoration(
                    errorMaxLines: 1,
                    errorText: !_validateOtp?"Enter valid OTP.":null,
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(_width*0.01)
                ),
              ),
            ),
            InkWell(
              onTap: (){
                isPressedResendOtp=true;
                resendOtp();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(_width*0.7, _height*0.02, _width*0.06, 0),
                child: Text("Resend OTP",style: TextStyle(
                    color: Colors.teal,
                    fontSize: 17,
                    fontWeight: FontWeight.w500
                ),),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: _height*0.1,
        color: Colors.white,
        child: InkWell(
          onTap: (){
            setState(() {
              _textOtp.text.length!=6 ? _validateOtp = false : _validateOtp = true;
            });
            if(_textOtp.text.length==6&&isPressed==false){
              isPressed=true;
              verifyHelper();

            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(_width*0.05, _height*0.015, _width*0.05, _height*0.015),
            height: _height*0.07,
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Center(child: AutoSizeText("Done",style: TextStyle(
                color: Colors.white,
                fontSize: 22
            ),
              maxLines: 1,
            )),
          ),
        ),
      ),
    );
  }
}

