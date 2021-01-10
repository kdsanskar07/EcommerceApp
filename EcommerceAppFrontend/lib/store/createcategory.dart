import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
class CreateCategory extends StatefulWidget {
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  @override
  Widget build(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    int isButtonDisable=1;
    void check(text){
      debugPrint(text);
      if(text==""){
        setState(() {
          debugPrint("vfhb");
          isButtonDisable=1;
        });
      }else{
        setState(() {
          debugPrint("vfhb");
          isButtonDisable=0;
        });
      }
    }
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){debugPrint("back");},
          icon: Icon(Icons.arrow_back,color: Colors.black,size: 24,),
        ),
        centerTitle: false,
        elevation: 0,
        title: Text("Create Category",style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_width*0.05),
            child: Container(
              decoration: BoxDecoration(
                border:Border(
                    bottom: BorderSide(width: 2,color: Colors.teal.withOpacity(0.5))
                ),
              ),
              child: TextField(
                onChanged: (text){
                  check(text);
                },
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                ),
                textCapitalization: TextCapitalization.words,
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                maxLength: 20,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Category Name',
                ),
              ),
            ),
          ),
          Container(
            height: _height*0.06,
            width: _width*0.35,
            margin: EdgeInsets.fromLTRB(_width*0.3, _height*0.8, 0, 0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              textColor: Colors.white,
              child: Text("Create"),
              onPressed: (){
                debugPrint("New category added");
                },
              color: Colors.indigo[900],
              disabledTextColor: Colors.white,
              disabledColor: Colors.indigo[900].withOpacity(0.7),
            ),
          )
        ],
      )
    );
  }
}
