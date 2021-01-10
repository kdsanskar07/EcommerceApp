class BusinessOrder{
  String orderId;
  String total;
  String storeStatus;
  BusinessOrder({this.orderId, this.total,this.storeStatus});
}

Map storeStatus = {
  "2":"Pending",
  "3":"Ready",
  "4":"picked",
  "5":"Declined",
  "6":"Accepted"
};