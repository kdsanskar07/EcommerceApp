const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;
const Store = require('./store.js');

const Bookmark = function(bookmark){
    this.storeId=bookmark.storeId;
    this.userId=bookmark.userId
}

Bookmark.createBookmarkPage = async function(storeId , userId){
    const connection = await dbConnection();
    let sqlquery = "insert into bookmark(userid,storeid) values (?,?);";
    const val = [userId,storeId];
    const bookmarkResponse = await executeQueryInsertSelectUpdate(connection,sqlquery ,val);
    console.log(bookmarkResponse);
    return {'id':bookmarkResponse.insertId};
};

Bookmark.deleteBookmarkPage = async function(storeId , userId){
    const connection = await dbConnection();
    let sqlquery = "DELETE FROM bookmark WHERE userid = ? AND storeid = ?";
    const val = [userId,storeId];
    const response = await executeQueryInsertSelectUpdate(connection , sqlquery ,val);
    return {'affectedNoOfRows': response.affectedRows};
};


Bookmark.isPresent = async (storeId,userId)=>{
    const connection = await dbConnection();
    let sqlquery = "select * from bookmark where userid =? and storeid =?";
    const val = [userId,storeId];
    const data = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    if(JSON.stringify(data) === '[]'){return {'data': false};}
    else{return {'data': true};}
    
};

Bookmark.fetchStore = async(connection,userId)=>{
    let sqlquery = "select storeid from bookmark where userid =?";
    const val = [userId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'noOfStoreFound':response.length,'data':response};
};

Bookmark.fetchStoreTransaction = async(userId)=>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
        connection.beginTransaction(async (error)=>{
            if(error)
                throw error;
            try{
                let storeList = [];
                // create product---------------------------------------------------
                const fetchResponse = await Bookmark.fetchStore(connection,userId);
                console.log(fetchResponse);
                for(let i=0 ; i<fetchResponse.noOfStoreFound; i++){
                    const temp = await Store.findStoreById(fetchResponse.data[i].storeid);
                    storeList.push(temp.store);
                }
                connection.commit(function(err) {
                    if (err) {
                      return connection.rollback(function() {
                        throw err;
                      });
                    }
                    console.log('Store data Saved successfully');
                });
                resolve({'noOfStoreFound':storeList.length,'storeList':storeList});
            }catch(error){
                console.log(error);
                reject(error);
            }
            });
        });

};

module.exports = Bookmark;