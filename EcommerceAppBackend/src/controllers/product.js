/**
 * The Product id to be insert in frontend(Android-Studio)
 * New attribute shopname is added
 */

const Product = require('../models/product.js');
const dbConnection = require("../../config/database.js");

const createProduct = async function(req,res){
    try{
        const productResponse = await Product.createProductTransaction(req.body,req.user.storeId);
        console.log('response: ',productResponse);
        return res.status(200).json({success:true , msg:'New Product Added'});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

const updateProduct = async (req ,res) =>{
    try{    
        const productResponse = await Product.updateProduct(req.body);
        console.log('response: ',productResponse);
        return res.status(200).json({success:true , msg:'Product Updated'});
    }
    catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

const deleteProduct = async (req ,res) =>{
    try{    
        const productResponse = await Product.deleteProductTransaction(req.body.id,req.body.categoryId,req.user.storeId);
        console.log('response: ',productResponse);
        return res.status(200).json({success:true , msg:'Product Deleted'});
    }
    catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

const getProductList = async (req,res) =>{
    try{
        console.log(req.body.categoryId);
        console.log(req.user.storeId);
        const response = await Product.getProductList(req.user.storeId,req.body.categoryId);
        return res.status(200).json({success:true,data:response});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please refresh'});
    }
}



module.exports.createProduct = createProduct;
module.exports.updateProduct = updateProduct;
module.exports.deleteProduct = deleteProduct;
module.exports.getProductList = getProductList;