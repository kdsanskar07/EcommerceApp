import 'package:e_commerce/authentication/signupotp.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final FlutterSecureStorage storage = FlutterSecureStorage();
  String email;
  String password;
  String confirmPassword;
  bool isPressed=false;
  final _formKey = GlobalKey<FormState>();

  Widget loginButton()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(width: _width*.13),
        Container(
          height: _height*.05,
          width: _width*.45,
          child: AutoSizeText(
            "Already have an account ? ",
            style: TextStyle(
                fontSize: 15.0
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: _height*.05,
            width: _width*.15,
            child: AutoSizeText(
                'Log in',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
         if(_formKey.currentState.validate())
         {
           if(isPressed==false){
             isPressed=true;
             Requests request = Requests(
               bodyData: {
                 'email' : email,
                 'password': password,
               },
               isHeader: false,
               context: context,
               url: 'http://10.0.2.2:3000/users/register',
             );
             request.postRequest().then((data) => {
               if(data!=null){
                 storage.write(key: 'email', value: email),
                 storage.write(key: 'password', value: password),
                 Navigator.push(
                     context, CupertinoPageRoute(builder: (context) => SignUpOtp())
                 ),
               }else{
                 isPressed=false,
               },
             });
           }
         }
      },
      child: Container(
        height: _height*.06,
        width: _width*.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Color.fromRGBO(67, 198, 172, 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 10,
                  offset: Offset(5,0)
              )
            ]
        ),
        padding: EdgeInsets.all(2),
        child: Center(
          child: AutoSizeText(
            'Sign Up',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationForm(){
    var _width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _width*.8,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            padding: EdgeInsets.all(5),
            child: TextFormField(
                decoration: InputDecoration(
                    icon: Icon(
                        Icons.email
                    ),
                    hintText: 'Enter your Email Address',
                    border: InputBorder.none
                ),
                validator: (value) {
                  value = value.trim();
                  if(!EmailValidator.validate(value)){
                    return 'Enter valid Email Address';
                  }
                  email = value;
                  return null;
                }
            ),
          ),
          Container(
            width: _width*.8,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            padding: EdgeInsets.all(5),
            child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(
                      Icons.lock
                  ),
                  hintText: 'Enter your Password',
                  border: InputBorder.none,
                  errorMaxLines: 1
                ),
                validator: (value) {
                  value = value.trim();
                  if(value.isEmpty || (value.length<6 || value.length>10)){
                    return 'Enter Password of length 6-10';
                  }
                  password = value;
                  return null;
                }
            ),
          ),
          Container(
            width: _width*.8,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            padding: EdgeInsets.all(5),
            child: TextFormField(
                obscureText: false,
                decoration: InputDecoration(
                  icon: Icon(
                      Icons.lock
                  ),
                  hintText: 'Confirm Password',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  value = value.trim();
                  if(value.isEmpty || (value.length<6 || value.length>10)){
                    return 'Enter Password of length 6-10';
                  }
                  if(value != password){
                    return "password don't match";
                  }
                  confirmPassword = value;
                  return null;
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget contentContainer()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints.tightForFinite(
          height: _height
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          color: Colors.white
      ),
      padding: EdgeInsets.symmetric(vertical:_height*.04,horizontal: _width*.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 15,
                      offset: Offset(0,10)
                  )
                ]
            ),
            child: registrationForm(),
          ),
          SizedBox(height: _height*.06),
          signUpButton(),
          SizedBox(height: _height*.05),
          loginButton()
        ],
      ),
    );
  }

  Widget imageContainer()
  {
    var _height = MediaQuery.of(context).size.height;
    return Hero(
      tag: 'cart_image',
      child: Image(
        image: AssetImage("assets/images/cart2.png"),
        height: _height*.27,
      ),
    );
  }

  Widget bodyContainer()
  {
    var _height = MediaQuery.of(context).size.height;
    return Container(
        height: _height,
        decoration: BoxDecoration(
          // color: Colors.teal
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromRGBO(67, 198, 172, 1),Color.fromRGBO(248, 255, 174, 1)]
            )
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: _height*.02),
            imageContainer(),
            contentContainer(),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: bodyContainer()
        )
    );
  }
}