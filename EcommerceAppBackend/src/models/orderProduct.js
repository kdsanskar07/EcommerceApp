const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;

const OrderProduct = function(orderProduct){
    this.orderId=orderProduct.orderId;
    this.productId=orderProduct.productId;
    this.quantity=orderProduct.quantity;
}

OrderProduct.addNewOrderProduct = async (connection,orderProduct)=>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="INSERT INTO orderproduct (orderId,productId,quantity) VALUES (?,?,?)";
    const val = [orderProduct.orderId,orderProduct.productId,orderProduct.quantity];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {id: response};
}

OrderProduct.getOrderProductsByOrderId = async(connection,orderId) =>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="select * from orderproduct where orderid=?";
    const val = [orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'noOfOrderProductsFound': response.length,'products': response};
}

OrderProduct.updateOrderQuantity = async(connection,quantity,productId,orderId) =>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="UPDATE orderproduct SET quantity=? where (productid=? AND orderid=?)";
    const val = [quantity,productId,orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

OrderProduct.updateOrderId = async(connection,orderId,newOrderId,productId) =>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="UPDATE orderproduct SET orderid=? where (productid=? AND orderid=?)";
    const val = [newOrderId,productId,orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

OrderProduct.removeOrderProduct = async(connection,orderId,productId) =>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="delete from orderproduct where (productid=? AND orderid=?)";
    const val = [productId,orderId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

module.exports = OrderProduct;