import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/authentication/resetPassword.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String email;
  bool taped=false;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String otp;
  bool isPressed = false;
  bool isResendPressed = false;


  Future<void> getEmail() async{
    email = await storage.read(key: 'forget_email');
    print(email);
  }

  @override
  void initState() {
    super.initState();
    getEmail();
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
            debugPrint("Back");
            Navigator.pop(context);
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
                child: AutoSizeText("Verify OTP", style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                ),
                  maxLines: 1,
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06,0, _width*0.06, _height*0.02),
              width: _width*0.9,
              child: AutoSizeText(email !=null?"Enter OTP sent to "+email:"",
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
                color: taped?Colors.teal:Colors.black45,
                fontWeight: FontWeight.w400,
              ),
                maxLines: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06, 0, _width*0.06, 0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, _height*0.0001),
              height: _height*0.08,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  validator: (value){
                    if(value.length != 6){
                      return 'OTP should be of 6 digits';
                    }
                    otp = value;
                    return null;
                  },
                  maxLength: 30,
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 1)),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(_width*0.01)
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                debugPrint("resend otp");
                Requests request = Requests(
                    bodyData: {
                      'email': email
                    },
                    context: context,
                    url: 'http://10.0.2.2:3000/users/resendOtpReset',
                    isHeader: false
                );
                request.postRequest();
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
            debugPrint("Enter New Password");
            print(email);
            print(otp);
            if(_formKey.currentState.validate()){
              if(isPressed==false){
                isPressed=true;
                Requests request = Requests(
                    bodyData: {
                      'email': email,
                      'otp' : otp
                    },
                    context: context,
                    url: 'http://10.0.2.2:3000/users/verifyOtp',
                    isHeader: false
                );
                request.postRequest().then((data) => {
                  print(data),
                  if(data!=null){
                    Navigator.push(
                            context, CupertinoPageRoute(builder: (context) => ResetPassword())
                    )
                  }else{
                    isPressed=false,
                  },
                });
              }
            }
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(_width*0.05, _height*0.015, _width*0.05, _height*0.015),
            height: _height*0.07,
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            child: Center(child: AutoSizeText("Done",style: TextStyle(
                color: Colors.white,
                fontSize: 18
            ),
              maxLines: 1,
            )),
          ),
        ),
      ),
    );
  }
}

