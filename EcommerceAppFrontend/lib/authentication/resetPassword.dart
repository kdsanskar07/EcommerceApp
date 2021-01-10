import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/authentication/login.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _cnf_visible=false;
  bool _new_visible=false;
  String email;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String password;
  bool isPressed = false;

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
                child: AutoSizeText("Reset Password", style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                ),
                  maxLines: 1,
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.07, _height*0.05, _width*0.06, 0),
              width: _width*0.8,
              height: _height*0.03,
              child: AutoSizeText("New Password",style: TextStyle(
                fontSize: 17,
                color: Colors.teal,
                fontWeight: FontWeight.w400,
              ),
                maxLines: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06, _height*.02, _width*0.06, 0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, _height*0.03),
              height: _height*0.08,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  validator: (value){
                    value = value.trim();
                    if(value.isEmpty || (value.length<6 || value.length>10)){
                      return 'Enter Password of length 6-10.';
                    }
                    password = value;
                    return null;
                  },
                  maxLength: 30,
                  obscureText: _new_visible,
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: true,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 1)),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(_width*0.01),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _new_visible = !_new_visible;
                          });
                        },
                        icon: Icon(
                          _new_visible?Icons.visibility:
                          Icons.visibility_off,
                          color: Colors.black87,
                        ),
                      )
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.07, _height*0.02, _width*0.06, 0),
              width: _width*0.8,
              height: _height*0.03,
              child: AutoSizeText("Confirm Password",style: TextStyle(
                fontSize: 17,
                color: Colors.teal,
                fontWeight: FontWeight.w400,
              ),
                maxLines: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(_width*0.06, _height*.02, _width*0.06, 0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, _height*0.03),
              height: _height*0.08,
              child: Form(
                key: _formKey2,
                child: TextFormField(
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  validator: (value){
                    value = value.trim();
                    if(value.isEmpty || (value.length<6 || value.length>10)){
                      return 'Enter Password of length 6-10.';
                    }
                    if(value != password){
                      return 'Password do not match.';
                    }
                    return null;
                  },
                  maxLength: 30,
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: true,
                  obscureText: _cnf_visible,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 1)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 1)),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(_width*0.01),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _cnf_visible = !_cnf_visible;
                          });
                        },
                        icon: Icon(
                          _cnf_visible?Icons.visibility:
                          Icons.visibility_off,
                          color: Colors.black87,
                        ),
                      )
                  ),
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
            debugPrint("password reset successfully");
            if(_formKey.currentState.validate() && _formKey2.currentState.validate()){
              if(isPressed==false){
                isPressed=true;
                Requests request = Requests(
                    bodyData: {
                      'email' : email,
                      'password': password
                    },
                    context: context,
                    url: 'http://10.0.2.2:3000/users/resetPassword',
                    isHeader: false
                );
                request.postRequest().then((data) => {
                  if(data!=null){
                    storage.delete(key: 'forget_email'),
                    storage.write(key: 'password', value: password),
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => LoginPage())
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

