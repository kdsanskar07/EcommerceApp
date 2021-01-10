const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;
const User = require('../models/user.js');
const CategoryStore = require('../models/categoryStore.js').CategoryStore

const Store = function(store)
{
    this.img = store.img;
    this.buildingNumber = store.buildingNumber;
    this.streetName = store.streetName;
    this.locality = store.locality;
    this.city = store.city;
    this.pinCode = store.pinCode;
    this.name = store.name;
    this.storeId =this.storeId;
    this.openingTime = store.openingTime;
    this.closingTime = store.closingTime;
    this.mob = store.mob;
    this.rating = store.rating;
    this.revenue = store.revenue;
    this.noOfOrders = store.noOfOrders;
    this.isOpenOnMonday = store.isOpenOnMonday;
    this.isOpenOnTuesday = store.isOpenOnTuesday;
    this.isOpenOnWednesday = store.isOpenOnWednesday;
    this.isOpenOnThrusday = store.isOpenOnThrusday;
    this.isOpenOnFriday = store.isOpenOnFriday;
    this.isOpenOnSaturday = store.isOpenOnSaturday;
    this.isOpenOnSunday = store.isOpenOnSunday;
    this.isBookmark = store.isBookmark;
    this.catgoryList = store.catgoryList;
}

//-------------------------------------------------------------------------------------------------------


// asyncronous function for creating new row (i.e: insert new store) in store table-----------------------

Store.createStore = async (connection,storeData,userId) =>{
    console.log(storeData);
    let sqlquery="INSERT INTO store (userid,buildingnumber,streetname,locality,pincode,name,openingtime,closingtime,mob,img,rating,revenue,nooforders,isopenonmonday,isopenontuesday,isopenonwednesday,isopenonthursday,isopenonfriday,isopenonsaturday,isopenonsunday) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    const val = [userId,storeData.buildingNumber,storeData.streetName,storeData.locality,storeData.pinCode,storeData.name,storeData.openingTime,storeData.closingTime,storeData.mob,storeData.img,storeData.rating,storeData.revenue,storeData.noOfOrders,storeData.isOpenOnMonday,storeData.isOpenOnTuesday,storeData.isOpenOnWednesday,storeData.isOpenOnThursday,storeData.isOpenOnFriday,storeData.isOpenOnSaturday,storeData.isOpenOnSunday];
    const StoreResponse = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': StoreResponse.insertId};
};

Store.createStoreTransaction = async (storeData,userId)=>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
    connection.beginTransaction(async (error)=>{
        if(error)
            throw error;
        try{
            // create store---------------------------------------------------
            const storeResponse = await Store.createStore(connection,storeData,userId);
            console.log(storeResponse);
            // add category--------------------------------------------------- 
            for(index=0;index<storeData.categoryList.length;index++){
                await CategoryStore.addNewCategory(connection,storeResponse.id,storeData.categoryList[index])
                console.log(index);
            }
            // add store id in user table ------------------------------------
            await User.updateStoreId(connection,storeResponse.id,userId);
            console.log('user');

            connection.commit(function(err) {
                if (err) {
                  return connection.rollback(function() {
                    throw err;
                  });
                }
                console.log('Store data Saved successfully');
            });
            resolve(storeResponse);
        }catch(error){
            console.log(error);
            reject(error);
        }
        });
    });
};

Store.findStoreById = async (storeId,connection) =>{
    if(connection == undefined){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM store WHERE id=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId]);
   // console.log(response);
    return {'noOfStoreFound':response.length,'store':response[0]};
}

Store.findStoreByPincode = async (pinCode,connection) =>{
    if(!connection){connection = await dbConnection();}
    let sqlquery="SELECT * FROM store WHERE pincode=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[pinCode]);
    console.log("Store Found By Pincode",response);
    return {'noOfStoreFound':response.length,'store':response};
}



Store.updateStore = async(storeData,userId) =>{
    const connection = await dbConnection();
    let sqlquery = "update store set userid=?,buildingnumber=?,streetname=?,locality=?,city=?,pincode=?,name=?,openingtime=?,closingtime=?,mob=?,img=?,rating=?,revenue=?,nooforders=?,isopenonmonday=?,isopenontuesday=?,isopenonwednesday=?,isopenonthursday=?,isopenonfriday=?,isopenonsaturday=?,isopenonsunday=?";
    const val = [userId,storeData.buildingNumber,storeData.streetName,storeData.locality,storeData.city,storeData.pinCode,storeData.name,storeData.openingTime,storeData.closingTime,storeData.mob,storeData.img,storeData.rating,storeData.revenue,storeData.noOfOrders,storeData.isOpenOnMonday,storeData.isOpenOnTuesday,storeData.isOpenOnWednesday,storeData.isOpenOnThursday,storeData.isOpenOnFriday,storeData.isOpenOnSaturday,storeData.isOpenOnSunday];
    const StoreResponse = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': StoreResponse.insertId};
}


// let storeData = new Store({
//     img: 'null',
//     buildingNumber: 2,
//     streetName: 'xved',
//     locality: 'sfds',
//     city: 'dcsvdv',
//     pinCode: '434342',
//     name: 'sfddsv',
//     storeId: '1',
//     openingTime: '12:30',
//     closingTime: '23:45',
//     mob:'955435344',
//     rating: 'vsvsdv',
//     revenue: 'frdvdf',
//     noOfOrders: 'fereefe',
//     isOpenOnMonday: 1,
//     isOpenOnTuesday: 0,
//     isOpenOnWednesday: 0,
//     isOpenOnThrusday: 1,
//     isOpenOnFriday: 0,
//     isOpenOnSaturday: 1,
//     isOpenOnSunday:0,
//     isBookmark: 0,
//     catgoryList: []
// });

// Store.createStore(storeData,1).then(data => {
//     console.log(data);
// }).catch(err => {
//     console.log(err);
// });

//-------------------------------------------------------------------------------------------------------


module.exports = Store;