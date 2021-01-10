const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate = require("./index.js").executeQueryInsertSelectUpdate;
const User = require("../models/user.js");


const Helper = function(helper){
    this.name = helper.name;
    this.email = helper.email;
    this.storeId = helper.storeId;
    this.otp = helper.otp;
    this.isVerified = helper.isVerified;
}

Helper.addHelper = async (helperData)=>{
    console.log(helperData);
    const connection = await dbConnection();
    let sqlquery = "insert into helper (storeid,email,name,otp,isverified) values (?,?,?,?,?);";
    const val = [helperData.storeId,helperData.email,helperData.name,helperData.otp,helperData.isVerified];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': response.insertId};
}
Helper.verify = async (connection,storeId,email)=>{
    let sqlquery = "update helper set isverified = 1 where storeid=? and email = ?";
    const val = [storeId,email];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

Helper.resendOtp = async (storeId,email)=>{
    const connection = await dbConnection();
    let sqlquery="SELECT * FROM helper WHERE storeid=? and email=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId,email]);
    if(response.length>0){
        return {'noOfHelperFound':response.length,'helperOtp':response[0].otp};
    }else{
        return {'noOfHelperFound':response.length};
    }
}

Helper.removeHelper = async (connection,storeId,email) => {
    let sqlquery="DELETE FROM helper WHERE storeid=? and email=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId,email]);
    console.log(response);
    return {'affectedNoOfRows': response.affectedRows};
}

Helper.getStoreHelper = async (storeId)=>{
    const connection = await dbConnection();
    let sqlquery="SELECT * FROM helper WHERE storeid=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId]);
    console.log(response);
    return {'noOfHelperFound':response.length,'helperList':response};
}

Helper.getHelper = async (storeId,email)=>{
    const connection = await dbConnection();
    let sqlquery="SELECT * FROM helper WHERE storeid=? and email=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId,email]);
    console.log(response);
    return {'noOfHelperFound':response.length,'helper':response[0]};
}

Helper.removeHelperTransaction = async (storeId,email) =>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
        connection.beginTransaction(async (error)=>{
            if(error)
                throw error;
            try{
                const helperResponse = await Helper.removeHelper(connection,storeId,email);
                const userResponse = await User.removeStoreIdHelper(connection,email);
                connection.commit(function(err) {
                    if (err) {
                      return connection.rollback(function() {
                        throw err;
                      });
                    }
                    console.log('Helper has been removed');
                });
                resolve({'msg':"Helper has been removed"});
            }catch(errror){
                console.log(error);
                reject(error);
            }
        })
    });
}

Helper.verifyHelperTransaction = async (storeId,email) =>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
        connection.beginTransaction(async (error)=>{
            if(error)
                throw error;
            try{
                const helperResponse = await Helper.verify(connection,storeId,email);
                const userResponse = await User.updateStoreIdHelper(connection,storeId,email);
                connection.commit(function(err) {
                    if (err) {
                      return connection.rollback(function() {
                        throw err;
                      });
                    }
                    console.log('Helper has been verified');
                });
                resolve({'msg':"Helper has been verified"});
            }catch(errror){
                console.log(error);
                reject(error);
            }
        })
    });
}

module.exports = Helper;