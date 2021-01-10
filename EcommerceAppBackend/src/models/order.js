const dbConnection = require("../../config/database.js");
const {executeQueryCreateTable,executeQueryInsertSelectUpdate}= require("./index.js");
const Product = require("./product.js");
const OrderProduct = require("./orderProduct");

// construtor for orders model----------------------------------------------------------------------------


const Order = function(order){
    this.id = order.id;
    this.status = order.status;
    this.placeTime = order.placeTime;
    this.paymentTime = order.paymentTime;
    this.processedTime = order. processedTime;
    this.pickupTime = order.pickupTime;
    this.shopName = order.shopName;
    this.total = order.total;
}

//-------------------------------------------------------------------------------------------------------

// let orderData = new Order({
//     status: 1,
//     PlaceTime: "2020-12-14 20:22:52.317",
//     paymentTime: "2020-12-14 20:22:52.317",
//     processedTime: "2020-12-14 20:22:59.317",
//     pickupTime: "2020-12-14 20:27:52.317",
//     total: '20000',
//     shopName: 'hello',
// });

//-------------------------------------------------------------------------------------------------------

// asyncronous function for creating new row (i.e: insert new order) in orders table-----------------------

Order.addOrder = async(connection,orderData,userId,storeId) => {
    let sqlquery="INSERT INTO orders (status,userid,storeid,placetime,processedtime,paymenttime,pickuptime,total) VALUES (?,?,?,?,?,?,?,?)";
    const val = [orderData.status,userId,storeId,orderData.placeTime,orderData.processedTime,orderData.paymentTime,orderData.pickupTime,orderData.total];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': response.insertId};
};

//-------------------------------------------------------------------------------------------------------
// const connection = await dbConnection();
// Order.addOrder(connection,orderData,1,5).then(res => {
//     console.log(res);
// }).catch(err => {
//     console.log(err);
// });

//-------------------------------------------------------------------------------------------------------

// asyncronous function for finding order by userId (i.e: finding order) in orders table-----------------------

Order.findUnplacedOrderByUserId = async(connection,userId) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM orders WHERE userid=? AND status=1";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[userId]);
    const data = response.length != 0? response[0].id:null;
    return {'unplacedOrderFound': response.length, 'orderId': data};
}

// asyncronous function for finding placed order by userId (i.e: finding order) in orders table-----------------------

Order.findplacedOrderByUserId = async(connection,userId) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM orders WHERE userid=? AND status!=1";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[userId]);
    return {'placedOrderFound': response.length, 'orderResponse': response};
}

// Order.findplacedOrderByUserId(null,2).then(res =>{
//     // console.log(res);
//     var d = res.orderId;
//     d.forEach(item => {
//         console.log(item);
//     })
// }).catch(err => {
//     console.log(err);
// });

// asyncronous function for finding order by userId (i.e: finding order) in orders table-----------------------

Order.getOrderDetailsByOrderId = async(connection,orderId) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM orders WHERE id=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[orderId]);
    const data = response.length != 0? response[0]:null;
    return {'unplacedOrderFound': response.length, 'data': data};
}

// asyncronous function for finding order by store(i.e: finding order) in orders table-----------------------

Order.getOrdersByStoreId = async(connection,storeId) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM orders WHERE storeid=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId]);
    return {'storeOrdersFound': response.length, 'data': response};
}


// template of calling function--------------------------
// Order.findUnplacedOrderByUserId(1).then(res =>{
//     console.log(res);
// }).catch(err =>{
//     console.log(err);
// });

// asyncronous function for finding order by userId (i.e: finding order) in orders table-----------------------

Order.updateOrderTotal = async(connection,orderId,total) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="UPDATE orders SET total=? where id=?";
    const val = [total,orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

// asyncronous function for finding order by userId (i.e: finding order) in orders table-----------------------

Order.deleteOrder = async(connection,orderId) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="DELETE from orders where id=?";
    const val = [orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

// asyncronous function for accepting store orders (i.e: finding order) in orders table-----------------------

Order.updateOrderStatus = async(connection,orderId,status,processedTime,pickupTime) => {
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery;
    let val;
    if(processedTime){
        sqlquery="UPDATE orders SET status=?,processedtime=? where id=?";
        val = [status,processedTime,orderId];
    }
    else if(pickupTime){
        sqlquery="UPDATE orders SET status=?,pickuptime=? where id=?";
        val = [status,pickupTime,orderId];
    }
    else{
        sqlquery="UPDATE orders SET status=? where id=?";
        val = [status,orderId];
    }
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}







//-------------------------------------------------------------------------------------------------------

// asyncronous function for finding orders by storeId (i.e: finding order) in orders table-----------------------

// Order.findplacedOrdersByStoreId = async (storeId) => {
//     const connection = await dbConnection();
//     let sqlquery="SELECT * FROM orders WHERE storeid=? AND status <> 1";
//     const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId]);
//     const data = response.length != 0? response[0].id:null;
//     return {'unplacedOrderFound': response.length, 'orderId': data};
// }

// template of calling function--------------------------
// Order.findplacedOrderByStoreId(1).then(res =>{
//     console.log(res);
// }).catch(err =>{
//     console.log(err);
// });

//-------------------------------------------------------------------------------------------------------

// asyncronous function for creating add to cart transition in orders table-----------------------

Order.addToCartTransition = async(userId,productId) =>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
        connection.beginTransaction(async(err)=>{
            if(err){
                throw err;
            }
            try{
                const findUnplaceOrder = await Order.findUnplacedOrderByUserId(connection,userId);
                let orderId;
                if(findUnplaceOrder.unplacedOrderFound){
                    orderId = findUnplaceOrder.orderId;
                }
                else{
                    const product = await Product.getProductDetails(connection,productId);
                    const storeId = product.storeid;
                    const orderData = new Order({
                        status: 1
                    });
                    const newOrder = await Order.addOrder(connection,orderData,userId,storeId);
                    orderId = newOrder.id;
                }
                const orderProduct = new OrderProduct({
                    orderId: orderId,
                    productId: productId,
                    quantity: 1
                })
                const response = await OrderProduct.addNewOrderProduct(connection,orderProduct);
                console.log(OrderProduct);
                connection.commit(function(err) {
                    if (err) {
                      return connection.rollback(function() {
                        throw err;
                      });
                    }
                    console.log('Order added to cart successfully');
                });
                resolve(response);
            }catch(error){
                console.log(error);
                reject(error);
            }
        })
    })
}

Order.checkOutOrderTransition = async(userId,productData)=>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
        connection.beginTransaction(async(err)=>{
            if(err){
                throw err;
            }
            try{
                const orderId = await (await Order.findUnplacedOrderByUserId(connection,userId)).orderId;
                console.log(orderId);
                for(let i=0;i<productData.length;i++){
                    await OrderProduct.updateOrderQuantity(connection,productData[i].quantity,productData[i].id,orderId);
                }
                console.log('orders updated');
                let map = new Map();
                for(let i=0;i<productData.length;i++){
                    const product = await (await Product.getProductDetails(connection,productData[i].id)).product;
                    const storeId = product[0].storeid;
                    console.log(storeId);
                    let newOrderId;
                    if(!map.get(storeId)){
                        const orderData = new Order({
                            status: 2,
                            placeTime: productData[i].placeTime,
                            paymentTime: productData[i].paymentTime,
                            total: (Number(product[0].price))*(Number(productData[i].quantity)),
                        });
                        const newOrder = await Order.addOrder(connection,orderData,userId,storeId);
                        console.log(newOrder);
                        newOrderId = newOrder.id;
                        map.set(storeId,newOrderId);
                    }else{
                        newOrderId = map.get(storeId);
                        const data = await Order.getOrderDetailsByOrderId(connection,newOrderId);
                        console.log(data);
                        var total = data.data.total;
                        total = Number(total) + (Number(product[0].price))*(Number(productData[i].quantity));
                        await Order.updateOrderTotal(connection,newOrderId,total);
                    }   
                    await OrderProduct.updateOrderId(connection,orderId,newOrderId,product[0].id);
                }
                const response = await Order.deleteOrder(connection,orderId);
                connection.commit(function(err) {
                    if (err) {
                      return connection.rollback(function() {
                        throw err;
                      });
                    }
                    console.log('Order placed successfully');
                });
                resolve(response);
            }catch(error){
                console.log(error);
                reject(error);
            }
    })
})
}

// Order.addToCartTransition(2,5).then(res => {
//     console.log(res);
// }).catch(err => {
//     console.log(err);
// })

module.exports = Order;
