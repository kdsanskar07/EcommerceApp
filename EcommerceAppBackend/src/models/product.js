const dbConnection = require("../../config/database.js");
const {CategoryStore}= require("./categoryStore.js");
const executeQueryInsertSelectUpdate = require("./index.js").executeQueryInsertSelectUpdate;


const Product = function(product){
    this.id = product.id;
    this.price = product.price;
    this.name = product.name;
    this.img = product.img;
    this.categoryId = product.categoryId ;
    this.storeId = product.storeId ;
    this.shopName = product.shopName;
    this.description = product.description ;
    this.totalQuantity = product.totalQuantity ;
    this.unit = product.unit ;
}

Product.addNewProduct = async function(connection ,product , storeId){
    console.log(product);
    let sqlquery = "insert into product(price,name,img,categoryid,storeid,description,totalquantity,unit) values (?,?,?,?,?,?,?,?);";
    const val = [product.price,product.name,product.img,product.categoryId,storeId,product.description,product.totalQuantity,product.unit];
    const productResponse = await executeQueryInsertSelectUpdate(connection , sqlquery ,val);
    console.log(productResponse);
    return {'id':productResponse.insertId};
};



Product.updateProduct = async (product)=>{   
        const connection = await dbConnection();
        let sqlquery = "UPDATE product SET price=?,name=?,img=?,categoryid=?,storeid=?,description=?,totalquantity=?,unit=? WHERE id = ?";
        const val = [product.price,product.name,product.img,product.categoryId,product.storeId,product.description,product.toatalQuantity,product.unit,product.id]
        const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
        return {'affectedNoOfRows': response.affectedRows};
};

Product.deleteProduct = async (connection,productId)=>{
    let sqlquery = "DELETE FROM product WHERE id = ?"
    const val = [productId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
};

Product.createProductTransaction = async (product,storeId)=>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
    connection.beginTransaction(async (error)=>{
        if(error)
            throw error;
        try{
            // create product---------------------------------------------------
            const productResponse = await Product.addNewProduct(connection,product,storeId);
            console.log(productResponse);

            // increment in category--------------------------------------------------- 

            await CategoryStore.createUpdateCategory(connection,product.categoryId,storeId);
            console.log('update query run');

            connection.commit(function(err) {
                if (err) {
                  return connection.rollback(function() {
                    throw err;
                  });
                }
                console.log('Store data Saved successfully');
            });
            resolve(productResponse);
        }catch(error){
            console.log(error);
            reject(error);
        }
        });
    });
};

Product.deleteProductTransaction = async (productId,categoryId,storeId)=>{
    const connection = await dbConnection();
    return new Promise((resolve,reject)=>{
    connection.beginTransaction(async (error)=>{
        if(error)
            throw error;
        try{
            // decrement in category--------------------------------------------------- 
            await CategoryStore.deleteUpdateCategory(connection,categoryId,storeId);
            console.log('update query run');
            // delete product---------------------------------------------------
            const response = await Product.deleteProduct(connection,productId);
            console.log(response);


            connection.commit(function(err) {
                if (err) {
                  return connection.rollback(function() {
                    throw err;
                  });
                }
                console.log('Store data Saved successfully');
            });
            resolve(response);
        }catch(error){
            console.log(error);
            reject(error);
        }
        });
    });
};

Product.getProductList = async (storeId,categoryId )=>{
    const connection = await dbConnection();
    let sqlquery = "select * from product where categoryid=? and storeid=?";
    const val = [categoryId,storeId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    console.log(response);
    return response;
};

Product.getProductDetails = async(connection,productId) =>{
    if(!connection){
        connection = await dbConnection();
    }
    let sqlquery="SELECT * FROM product WHERE id=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[productId]);
    console.log(response);
    return {'noOfProductFound':response.length,'product':response};
}

module.exports = Product;