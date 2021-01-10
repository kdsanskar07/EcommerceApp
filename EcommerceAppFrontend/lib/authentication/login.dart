import 'package:e_commerce/authentication/forgotpassword.dart';
import 'package:e_commerce/class/user.dart';
import 'package:e_commerce/customer/homepage.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:e_commerce/authentication/register.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   UserInfo userInfo;
  Future<void> getEmailPassword() async{
    rememberedEmail = await storage.read(key: 'rememberedEmail');
    rememberedPassword = await storage.read(key: 'rememberedPassword');
  }
  @override
  void initState() {
    super.initState();
    getEmailPassword();
  }

   Future<void> getUserDetail() async {
     Requests request = new Requests(
         isHeader: true,
         bodyData: null,
         context: context,
         url: 'http://10.0.2.2:3000/users/getuserdetail'
     );
     var response = await request.getRequest();
       userInfo = new UserInfo(
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
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool checkValue = false;
  bool visible = true;
  var isPressed = false;
  String email;
  String password;
  String rememberedEmail;
  String rememberedPassword;
  final _formKey = GlobalKey<FormState>();

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if(authenticated)
    {
      email = await storage.read(key:'email');
      password = await storage.read(key:'password');
      print(email);
      print(password);
      if(isPressed==false){
        isPressed=true;
       sendLoginDetails();
      }
    }
    setState(() {
      _authorized = message;
    });
  }

  Widget createLoginForm()
  {
    var _controller1 = TextEditingController(text: rememberedEmail);
    var _controller2 = TextEditingController(text: rememberedPassword);
    var _width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              padding: EdgeInsets.only(left: _width*.013),
              constraints: BoxConstraints.tightForFinite(
                width: _width*.8
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: TextFormField(
                onChanged: (value){
                  rememberedEmail = value;
                },
                controller: _controller1,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  value = value.trim();
                  if(!EmailValidator.validate(value)){
                    return 'Enter valid email.';
                  }
                  email = value;
                  return null;
                },
                decoration: InputDecoration(

                  icon: Icon(
                      Icons.email
                  ),
                  hintText: 'Enter your Email Address',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              constraints: BoxConstraints.tightForFinite(
                  width: _width*.9
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              padding: EdgeInsets.all(5),
              child: TextFormField(
                controller: _controller2,
                onChanged: (value) {
                  rememberedPassword = value;
                },
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Enter valid password';
                  }
                  password = value;
                  return null;
                },
                obscureText: visible,
                decoration: InputDecoration(
                    icon: Icon(
                        Icons.lock
                    ),
                    hintText: 'Enter your Password',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: Icon(
                        visible?Icons.visibility:
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
    );
  }
  Future<void> sendLoginDetails() async {
    Requests request = Requests(
        bodyData: {
          'email' : email,
          'password': password,
        },
        context: context,
        url: 'http://10.0.2.2:3000/users/login',
        isHeader: false
    );
    var data = await request.postRequest();
    if(data!=null){
      print(data['token']);
      print(data['expiresIn']);
      storage.write(key: 'token', value: data['token']);
      storage.write(key: 'expiresIn', value: data['expiresIn']);
      await getUserDetail();
      Navigator.push(
      context, CupertinoPageRoute(builder: (context) => HomePage(userInfo : userInfo))
      );
    }else{
      isPressed=false;
    }
  }
  Widget fingerPrintButton()
  {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
        
      ),
      child: IconButton(
        onPressed: (){
            _authenticate();
          },
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.fingerprint,
          size: 40,
        ),
      ),
    );
  }

  Widget loginButton()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){

        if(_formKey.currentState.validate())
        {
          if(isPressed==false){
            if(checkValue == true){
              print(checkValue);
              storage.write(key: 'rememberedEmail', value: rememberedEmail);
              storage.write(key: 'rememberedPassword', value: rememberedPassword);
            }
            isPressed=true;
            sendLoginDetails();
          }
        }
      },
      child: Container(
        height: _height*.06,
        width: _width*.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromRGBO(67, 198, 172, 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 20,
                  offset: Offset(0,10)
              )
            ]
        ),
        padding: EdgeInsets.all(2),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  Widget forgetPassword()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(width: _width*.15),
        Container(
          width: _width*.32,
          height: _height*.025,
          child: AutoSizeText(
            'Forget Password ? ',
            style: TextStyle(
                fontSize: 15.0
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            debugPrint("Forget Password");
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => ForgotPassword())
            );
          },
          child: Container(
            width: _width*.32,
            height: _height*.025,
            child: AutoSizeText(
                'Click here',
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

  Widget signUp()
  {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        SizedBox(width: _width*.155),
        Container(
          width: _width*.34,
          height: _height*.04,
          child: AutoSizeText(
            "Don't have account ? ",
            style: TextStyle(
                fontSize: 15.0
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => RegisterPage())),
          child: Container(
            width: _width*.15,
            height: _height*.04,
            child: AutoSizeText(
                'Sign Up',
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

  Widget contentContainer()
  {
    var _height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints.tightForFinite(
        height: _height
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          color: Colors.white
      ),
      padding: EdgeInsets.all(_height*.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(_height*.02),
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
            child: createLoginForm(),
          ),
          SizedBox(height: _height*.015),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "Remember me",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            value: checkValue,
            onChanged: (bool value){
              setState(() {
                checkValue = value;
              });
            },
          ),
          fingerPrintButton(),
          SizedBox(height: _height*.018),
          loginButton(),
          SizedBox(height: _height*.03),
          forgetPassword(),
          SizedBox(height: _height*.055),
          signUp()
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
        image: AssetImage("assets/images/cart.png"),
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
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromRGBO(67, 198, 172, 1),Color.fromRGBO(248, 255, 174, 1)]
            )
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: _height*.025),
            imageContainer(),
            contentContainer()
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