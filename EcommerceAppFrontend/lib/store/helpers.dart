import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_commerce/class/helper.dart';
import 'package:e_commerce/others/requests.dart';
import 'package:e_commerce/store/verifyhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Helper extends StatefulWidget {
  @override
  _HelperState createState() => _HelperState();
}

class _HelperState extends State<Helper> {

  List<HelperInfo> data=[];
  bool isAddSuccsesful=false;
  bool isCancel=true;
  bool getHelper = false;

  Future<void> getHelperList() async {
    data = [];
    Requests request = new Requests(
        isHeader: true,
        bodyData: null,
        context: context,
        url: 'http://10.0.2.2:3000/helper/getstorehelpers'
    );
    var response = await request.getRequest();
    print("value: "+response['data'].toString());
    for(int i=0;i<response['data']['helperList'].length;i++){
      HelperInfo temp  = HelperInfo(
        name: response['data']['helperList'][i]['name'],
        email: response['data']['helperList'][i]['email'],
        isVerified: response['data']['helperList'][i]['isverified'],
      );
      data.add(temp);
    }
  }
  Future<void> removeHelper(email) async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: {"email":email},
        context: context,
        url: 'http://10.0.2.2:3000/helper/removehelper'
    );
    var response = await request.postRequest();
    if(response!=null && response['success']==true){
      await getHelperList();
      setState(() {
        getHelper=true;
      });
    }else{
      setState(() {
        getHelper=true;
      });
    }
  }

  Future<void> addNewHelper(email) async {
    Requests request = new Requests(
        isHeader: true,
        bodyData: {"email":email},
        context: context,
        url: 'http://10.0.2.2:3000/helper/createhelper'
    );
    var response = await request.postRequest();
    print(response);
    if(response!=null && response['success']==true){
      await getHelperList();
      setState(() {
        getHelper=true;
      });
    }else{
      setState(() {
        getHelper=true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHelperList().then((value) => {
      setState(() {
        getHelper=true;
      }),
    });
  }

  Widget helperCard(HelperInfo data) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: (){
        if(data.isVerified==0){
          Navigator.push(
              context, CupertinoPageRoute(
            builder: (context) => VerifyHelper(data: data,),
          )
          );
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(_width*0.05, 0, _width*0.05, _height*0.01),
            padding: EdgeInsets.fromLTRB(_width*0.04,_height*0.026,_width*0.04,0),
            height: _height*0.11,
            width: _width*0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(1,2),
                    spreadRadius: 1,
                    color: Colors.grey[300],
                    blurRadius: 5
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: _height*0.01,),
                Container(
                  width: _width*0.7,
                  height: _height*0.025,
                  child: AutoSizeText(data.name,style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
                Container(
                  // color: Colors.red,
                  width: _width*0.7,
                  height: _height*0.025,
                  child: Text(data.email,style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.teal
                  ),),
                ),
              ],
            ),
          ),
          Positioned(
              top: _height*0.035,
              left: _width*0.8,
              child: IconButton(
                onPressed: (){
                  debugPrint("Delete this helper");
                  setState(() {
                    getHelper=false;
                  });
                  removeHelper(data.email);
                },
                icon: Icon(Icons.delete_outline,size: 30,color: Colors.red[400],),
              )
          ),
          data.isVerified==0?Positioned(
              top: _height*0.015,
              left: _width*0.76,
              child: Container(
                // color: Colors.red,
                width: _width*0.16,
                height: _height*0.022,
                child: AutoSizeText("Pending",style: TextStyle(
                  color: Colors.blue,
                ),),
              )
          ):Container(),
        ],
      ),
    );
  }
  void bottomSheet(bool isAddSuccsesful,bool isCancel) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    final _textEmail = TextEditingController();
    bool isPressedSend= false;
    isAddSuccsesful=false;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.teal.withOpacity(0),
        builder: (context)=>Container(
          height: _height*0.25,
          child: Center(
            child: Container(
              height: _height*0.2,
              width: _width*0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(_width*0.05,_height*0.02,_width*0.05,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width:_width,
                      child: Center(
                        child: Container(
                          height: _height*0.03,
                          width: _width*0.4,
                          child: AutoSizeText("Enter email address",style: TextStyle(
                            color: Colors.teal,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),),
                        ),
                      ),
                    ),
                    SizedBox(height: _height*0.02,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[400],
                            width: 1,
                          )
                      ),
                      child: TextField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        controller: _textEmail,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[900],
                        ),
                        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                        maxLength: 30,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: _height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: _width*0.25,),
                        InkWell(
                          onTap: (){
                            debugPrint("cancel adding helper");
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: _height*0.03,
                            width: _width*0.15,
                            child: AutoSizeText("Cancel",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontSize: 18,
                            ),),
                          ),
                        ),
                        SizedBox(width: _width*0.1,),
                        InkWell(
                          onTap: (){
                            if(isPressedSend==false){
                              debugPrint("Send request to helper");
                              setState(() {
                                getHelper=false;
                              });
                              addNewHelper(_textEmail.text);
                              isAddSuccsesful=true;
                              isCancel=false;
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            height: _height*0.03,
                            width: _width*0.3,
                            child: AutoSizeText("Send Request",style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                              fontSize: 18,
                            ),),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );

  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: (){
            debugPrint("Add new helper");
            bottomSheet(isAddSuccsesful,isCancel);
            if(!isCancel){
              isCancel=false;
              if(isAddSuccsesful){
                isAddSuccsesful=false;
                //Todo add SnackBar
              }
            }
          },
          child: new Icon(Icons.add),
        ),
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text("Helpers"),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            debugPrint(
              "Back"
            );
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
        body: getHelper?ListView(
          children: <Widget>[
            SizedBox(height: _height*0.03,),
            Container(
              height: _height*0.12*data.length,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int index){
                  return helperCard(data[index]);
                },
                itemCount: data.length,
                ),
          ),
        ],
      ):Container(
          height: _height,
          width: _width * .8,
          color: Colors.white,
        ),
    );
  }
}