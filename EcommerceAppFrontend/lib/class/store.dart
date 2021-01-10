// Since Number of customer can be much greater than number of store owners so sending store id is good
// and since we are not using jwt auth while sending api request so he can make as much harm using his email as with store id

class StoreInfo{
  String mob,name,img,rating,revenue,noOfOrders,openingTime,closingTime,storeId,buildingNumber,streetName,city,locality,pinCode;
  int isOpenOnMonday,isOpenOnTuesday,isOpenOnWednesday,isOpenOnThursday,isOpenOnFriday,isOpenOnSaturday,isOpenOnSunday,isBookmark;
  List <dynamic> categoryList;
StoreInfo({
    this.pinCode,this.city,this.buildingNumber,this.locality,
    this.streetName,this.isBookmark,this.name, this.revenue,
    this.img, this.noOfOrders, this.rating, this.isOpenOnFriday,
    this.isOpenOnMonday, this.isOpenOnSaturday, this.isOpenOnSunday,
    this.isOpenOnThursday, this.isOpenOnTuesday, this.isOpenOnWednesday,
    this.mob, this.openingTime, this.closingTime, this.storeId,
    this.categoryList
  });
  Map getStore(){
    return {
      'mob': mob, 'name' : name, 'img':img, 'rating':rating,
      'revenue':revenue, 'noOfOrders':noOfOrders, 'openingTime':openingTime,
      'closingTime':closingTime, 'buildingNumber':buildingNumber, 'streetName':streetName,
      'city':city, 'locality':locality, 'pinCode':pinCode, 'isOpenOnSunday':isOpenOnSunday,
      'isOpenOnSaturday':isOpenOnSaturday, 'isOpenOnFriday':isOpenOnFriday,
      'isOpenOnThursday':isOpenOnThursday, 'isOpenOnWednesday':isOpenOnWednesday,
      'isOpenOnTuesday':isOpenOnTuesday, 'isOpenOnMonday':isOpenOnMonday,
      'isBookmark':isBookmark,'categoryList':categoryList,
    };
  }
}