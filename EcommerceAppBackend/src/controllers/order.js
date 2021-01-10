const Order = require('../models/order.js');
const OrderProduct = require('../models/orderProduct.js');
const Product = require('../models/product.js');
const Store = require('../models/store.js');
const User = require('../models/user.js');
const redis = require('redis');
const mailSender = require('../../lib/mail.js');
const utils = require('../../lib/utils.js');
const dbConnection = require("../../config/database.js");


const getCartDetails = async(req,res) =>{
    try{
        const connection = await dbConnection();
        const unplacedOrder = await Order.findUnplacedOrderByUserId(connection,req.user.id);
        console.log(unplacedOrder);
        const data = {
            numOfOrders:0,
            orderDetails:null
        };
        if(unplacedOrder.unplacedOrderFound === 0){
            return res.status(200).json({success:true, data:data});
        }
        const orderId = unplacedOrder.orderId;
        const orderProductsDetails = await OrderProduct.getOrderProductsByOrderId(connection,orderId);
        const productList = orderProductsDetails.products;
        let orderProducts = [];
        for(let i=0;i<productList.length;i++){
            const productDetails = await Product.getProductDetails(connection,productList[i].productid);
            const storeName = await (await Store.findStoreById(productDetails.product[0].storeid)).store.name;
            const product = new Product({
                id: productDetails.product[0].id,
                price: productDetails.product[0].price,
                name: productDetails.product[0].name,
                shopName: storeName
            });
            orderProducts.push(product);
        };
        data.numOfOrders = orderProductsDetails.noOfOrderProductsFound;
        data.orderDetails = orderProducts;
        return res.status(200).json({success:true, data:data});
    }catch{
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const checkoutOrders = async(req,res) =>{
    try{
        const orderResponse = await Order.checkOutOrderTransition(req.user.id,req.body);
        console.log('response: ',orderResponse);
        return res.status(200).json({success:true,msg:'orders placed sucessfully'});        
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const removeProduct = async(req,res) =>{
    try{
        const orderId = await (await Order.findUnplacedOrderByUserId(null,req.user.id)).orderId;
        const response = await OrderProduct.removeOrderProduct(null,orderId,req.body.id);
        console.log(response);
        return res.status(200).json({success:true,msg:'orders removed sucessfully'});        
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const getUserOrders = async(req,res)=>{
    try{
        const connection = await dbConnection();
        const response = await Order.findplacedOrderByUserId(connection,req.user.id);
        for(let i=0;i<response.placedOrderFound;i++){
            const shopInfo = await Store.findStoreById(response.orderResponse[i].storeid,connection);
            response.orderResponse[i].storename = shopInfo.store.name;
            response.orderResponse[i].shopmob = shopInfo.store.mob;
            response.orderResponse[i].buildingnumber = shopInfo.store.buildingnumber;
            response.orderResponse[i].streetname = shopInfo.store.streetname;
            response.orderResponse[i].locality = shopInfo.store.locality;
            response.orderResponse[i].pincode = shopInfo.store.pincode;
        }
        return res.status(200).json({success:true,data: response.orderResponse});        
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const getStoreOrders = async(req,res)=>{
    try{
        const storeOrderDetails = await Order.getOrdersByStoreId(null,req.user.storeId);
        return res.status(200).json({success:true,data: storeOrderDetails.data}); 
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const acceptStoreOrders = async(req,res)=>{
    try{
        const response = await Order.updateOrderStatus(null,req.body.orderId,"6",req.body.processedTime,null);
        console.log(response);
        return res.status(200).json({success:true,msg:'order Accepted'}); 
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const cancelStoreOrders = async(req,res)=>{
    try{
        const response = await Order.updateOrderStatus(null,req.body.orderId,"5",null,null);
        console.log(response);
        return res.status(200).json({success:true,msg:'order Cancelled'}); 
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const readyStoreOrders = async(req,res)=>{
    try{
        const redisClient = redis.createClient();
        const userId = await (await Order.getOrderDetailsByOrderId(null,req.body.orderId)).data.userid;
        const userEmail = await (await User.findUserById(userId)).user.email;
        let otp = Math.floor(100000 + Math.random() * 900000).toString();
        const key = req.body.orderId;
        const val = otp;
        redisClient.set(key,val);
        redisClient.expire(otp,86400);
        const responsemail = await mailSender.sendEmail(userEmail,otp);
        const response = await Order.updateOrderStatus(null,req.body.orderId,"3",null,req.body.pickupTime);
        return res.status(200).json({success:true,msg:'order ready to be picked'}); 
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const pickStoreOrder = async(req,res)=>{
    try{
        const { promisify } = require("util");
        const redisClient = redis.createClient();
        const key = req.body.orderId.toString();
        const getAsync = promisify(redisClient.get).bind(redisClient);
        var result = await getAsync(key);
        if(result){
            if(req.body.otp===result){
                const response = await Order.updateOrderStatus(null,req.body.orderId,"4");
                return res.status(200).json({success:true,msg:'Order Picked Sucessfully'});
            }
            else{
                return res.status(200).json({success:false,msg:'Incorrect OTP'});
            }
        }
        else{
            return res.status(400).json({success:false,msg:'Otp expired! Please provide email again'});
        }
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Please retry again'});
    }
}

const addToCart = async(req,res)=>{
    try{
        const response = await Order.addToCartTransition(req.user.id,req.body.productId);
        return res.status(200).json({success:true,msg:'Product added to cart'});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Please retry again'});
    }
}

const getOrderProduct = async(req,res)=>{
    try{
        const connection = await dbConnection();
        const orderProduct = await OrderProduct.getOrderProductsByOrderId(connection,req.body.id);
        let responseProducts = {};
        for(let i=0;i<orderProduct.noOfOrderProductsFound;i++){
            const productDetails = await Product.getProductDetails(connection,orderProduct.products[i].productid);
            if(responseProducts[productDetails.product[0].categoryid] == undefined){
                responseProducts[productDetails.product[0].categoryid] = [];
            }
            let product = {};
            product.quantity = orderProduct.products[i].quantity;
            product.name = productDetails.product[0].name;
            product.priceperpiece = productDetails.product[0].price;
            responseProducts[productDetails.product[0].categoryid].push(product);
        }
        return res.status(200).json({success:true,data: responseProducts});   
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

module.exports.getCartDetails = getCartDetails;
module.exports.checkoutOrders = checkoutOrders;
module.exports.removeProduct = removeProduct;
module.exports.getUserOrders = getUserOrders;
module.exports.getOrderProduct = getOrderProduct;
module.exports.getStoreOrders = getStoreOrders;
module.exports.acceptStoreOrders = acceptStoreOrders;
module.exports.cancelStoreOrders = cancelStoreOrders;
module.exports.readyStoreOrders = readyStoreOrders;
module.exports.pickStoreOrder = pickStoreOrder;
module.exports.addToCart = addToCart;
