const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;

const CategoryStore = function(categoryStore){
    this.storeId=categoryStore.storeId;
    this.categoryId=categoryStore.categoryId;
    this.noOfProducts=categoryStore.noOfProducts;
}

CategoryStore.addNewCategory = async (connection,storeId,categoryId)=>{
    let sqlquery="INSERT INTO categorystore (storeid,categoryid,noofproducts) VALUES (?,?,?)";
    const val = [storeId,categoryId,'0'];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
}

CategoryStore.getCategoryList = async (storeId,connection)=>{
    if(!connection){connection = await dbConnection();}
    //console.log(storeId);
    
    let sqlquery="SELECT * FROM categorystore WHERE storeid=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[storeId]);
    // console.log(response);
    // console.log(response.length);
    let categoryList=[];
    let noOfProductsList=[];
    for(i=0;i<response.length;i++){
        // console.log(response[i].categoryid);
        categoryList.push(response[i].categoryid);
        noOfProductsList.push(response[i].noofproducts);
    }
    //console.log(categoryList);
    //console.log(noOfProductsList);
    return {'categoryList':categoryList,'noOfProductList':noOfProductsList};
}

CategoryStore.createUpdateCategory = async function(connection,categoryId,storeId){
    console.log("cat: "+categoryId);
    console.log("store: "+storeId);
    let sqlquery = "update categorystore set noofproducts = noofproducts+1 where categoryid = ? and storeid = ?";
    const val = [categoryId,storeId];
    const response = await executeQueryInsertSelectUpdate(connection , sqlquery ,val);
    console.log(response);
    return {'affectedNoOfRows': response.affectedRows};
};

CategoryStore.deleteUpdateCategory = async function(connection,categoryId , storeId){
    let sqlquery = "update categorystore set noofproducts = noofproducts-1 where categoryid = ? and storeid = ?";
    const val = [categoryId,storeId];
    const response = await executeQueryInsertSelectUpdate(connection , sqlquery ,val);
    console.log(response);
    return {'affectedNoOfRows': response.affectedRows};
};


// CategoryStore.getCategoryList(13);

// addNewCategory(1,1).then(data=>{
//     console.log('data: ',data);
// }).catch(error=>{
//     console.log(error);
// });



module.exports.CategoryStore=CategoryStore;