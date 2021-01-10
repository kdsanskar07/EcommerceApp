// User type will be pre-define :- Customer , Helper , Owner.

class UserInfo {
  String name,email,mob,dob,gender,pic,type,buildingNumber,streetName,city,locality,pinCode;
  UserInfo({this.name, this.email, this.mob, this.dob, this.gender, this.pic, this.type, this.pinCode, this.city, this.locality, this.streetName, this.buildingNumber});
  Map getUser(){
    return {
        "email": email,
        "name": name,
        "dob": dob,
        "mob": mob,
        "gender": gender,
        "pic": pic,
        "type": type,
        "buildingNumber": buildingNumber,
        "streetName": streetName,
        "city": city,
        "locality": locality,
        "pinCode": pinCode,
      };
  }
}
