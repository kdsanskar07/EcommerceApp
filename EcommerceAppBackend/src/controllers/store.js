const Store = require('../models/store.js');
const CategoryStore = require('../models/categoryStore.js').CategoryStore;
const dbConnection = require("../../config/database.js");

const register = async (req,res)=>{
    try{
        const storeResponse = await Store.createStoreTransaction(req.body,req.user.id);
        console.log('response: ',storeResponse);
        return res.status(200).json({success:true,data:storeResponse});        
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const getStoreDetail = async (req,res)=>{
    try{
        console.log(req.user);
        const storeResponse = await Store.findStoreById(req.user.storeId);
        return res.status(200).json({success:true,data:storeResponse.store});
    }catch{
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const getStorePincode = async (req,res)=>{
    try{
        const connection = await dbConnection();
        //console.log(req.user.pinCode);
        const storeResponse = await Store.findStoreByPincode(req.user.pinCode,connection);
        console.log("hgbibgi:------",storeResponse);
        for(let i=0;i<storeResponse.store.length;i++){
            const response = await CategoryStore.getCategoryList(storeResponse.store[i].id,connection);
            storeResponse.store[i].categoryList = response.categoryList;
        }
        return res.status(200).json({success:true,data:storeResponse.store});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
}

const updateStore = async (req ,res) =>{
    try{    
        const storeResponse = await Store.updateStore(req.body,req.user.id);
        console.log('response: ',storeResponse);
        return res.status(200).json({success:true , msg:'Product Updated'});
    }
    catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

module.exports.register = register;
module.exports.getStoreDetail = getStoreDetail;
module.exports.updateStore = updateStore;
module.exports.getStorePincode = getStorePincode;