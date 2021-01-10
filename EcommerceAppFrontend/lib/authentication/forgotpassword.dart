import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/authentication/Otp.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final _formKey2 = GlobalKey<FormState>();
  String email;
  bool isPressed = false;

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
                child: AutoSizeText("Forgot Password", style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06,0, _width*0.06, _height*0.02),
              width: _width*0.9,
              child: AutoSizeText("Please enter the email address. We will send you an email with instructions to reset your password.",
              style: TextStyle(
                height: 1.5,
                fontSize: 15,
                color: Colors.black54,
              ),
                maxLines: 2,
              ),
            ),
            Form(
              key: _formKey2,
              child: Padding(
                padding: EdgeInsets.only(left: _width*.07,right: _width*.07),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  validator: (value) {
                    value = value.trim();
                    if(!EmailValidator.validate(value) || value == null){
                      return 'Enter valid Email Address';
                    }
                    email = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.teal
                    ),
                    focusColor: Colors.teal
                  ),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: _height*0.1,
        color: Colors.white,
        child: InkWell(
          onTap: (){
            debugPrint("Enter OTP");
            if(_formKey2.currentState.validate()){
              if(isPressed==false){
                isPressed=true;
                Requests request = Requests(
                  bodyData: {
                    'email' : email
                  },
                  context: context,
                  url: 'http://10.0.2.2:3000/users/forgetPassword',
                  isHeader: false
                );
                request.postRequest().then((data) => {
                  print(data),
                  if(data!=null){
                    storage.write(key: 'forget_email', value: email),
                    Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Otp())
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
            child: Center(child: AutoSizeText("SUBMIT",style: TextStyle(
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
