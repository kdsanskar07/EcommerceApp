// Status :- Unplaced , Intransit , Accepted , Ready to pickup , picked , Cancelled

class OrderInfo {
  String queueNum;
  String orderId;
  String status;
  String shopName;
  String userId;
  String placeDate;
  String placeTime;
  String paymentTime;
  String processTime;
  String pickedTime;
  String orderTotal;

  // List<ProductInfo> products = [];
  OrderInfo({
    this.queueNum,
    this.orderId,
    this.status,
    this.shopName,
    this.userId,
    this.placeDate,
    this.placeTime,
    this.paymentTime,
    this.processTime,
    this.pickedTime,
    this.orderTotal,
  });
}

