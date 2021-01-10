const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;


// construtor for USERS model----------------------------------------------------------------------------

// usertype is of three types -- 1 - customer
//                               2 - owner
//                               3 - helper

const User = function(user){
    this.id = user.id;
    this.email = user.email;
    this.name = user.name
    this.dob = user.dob
    this.mob = user.mob
    this.gender = user.gender;
    this.pic = user.pic;
    this.type = user.type;
    this.hash = user.hash;
    this.salt = user.salt;
    this.buildingNumber = user.buildingNumber;
    this.streetName = user.streetName;
    this.city = user.city;
    this.locality = user.locality;
    this.pinCode = user.pinCode;
    this.storeId = user.storeId;
}

//-------------------------------------------------------------------------------------------------------


// asyncronous functions for Query Execution ------------------------------------------------------------

// const executeQueryCreateTable = async (connection,sqlquery)=>{
//     return new Promise((resolve,reject)=>{
//         connection.execute(sqlquery,(error,response)=>{
//             if(error)  return reject(error);
//             return resolve(response);
//         });
//     })
// };

// const executeQueryInsertSelectUpdate = async (connection,sqlquery,Data) =>{
//     return new Promise((resolve,reject)=>{
//         connection.query(sqlquery,Data,(error,response)=>{
//             if(error) return reject({'sqlErrorCode': error.code,'sqlErrorNumber':error.errno,'errorMessage':error.sqlMessage});
//             return resolve(response);
//         });
//     })
// };

//-------------------------------------------------------------------------------------------------------


// asyncronous function for creating USERS table---------------------------------------------------------

// const createTable = async () =>{
//     const connection = await dbConnection();
//     let sqlquery = "CREATE TABLE IF NOT EXISTS users (userid INT AUTO_INCREMENT PRIMARY KEY,username VARCHAR(40),useremail VARCHAR(30) UNIQUE NOT NULL,userhash VARCHAR(300) NOT NULL,usersalt VARCHAR(300) NOT NULL,user)";
//     const response = executeQueryCreateTable(connection,sqlquery);
//     return response;
// };

// template of calling function--------------------------

// createTable().then(data=>{
//     console.log("users table created: ",data);
// }).catch(err =>{
//     console.log("error: ", err);
// });

//-------------------------------------------------------------------------------------------------------


// asyncronous function for creating new row (i.e: insert new user) in USERS table-----------------------

User.createUser = async (userData) =>{
    const connection = await dbConnection();
    let sqlquery="INSERT INTO user (name,email,hash,salt,dob,gender,mob,pic,type,buildingnumber,streetname,locality,city,pincode) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    const val = [userData.name,userData.email,userData.hash,userData.salt,userData.dob,'male',userData.mob,userData.pic,'1',userData.buildingNumber,userData.streetName,userData.locality,userData.city,userData.pinCode];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': response.insertId};
};

// template of calling function--------------------------

// let userdata = new User({
//     email: '1@gmail.com',
//     hash: 'gbhcnslkcmsokcnsonciwhvnk',
//     salt: 'dcbnxsckscnslmls'
// });

// User.createUser(userdata).then(data =>{
//     console.log('user created with userId: ',data.userId);
// }).catch(error => {
//     console.log('error: ', error);
// });

//-------------------------------------------------------------------------------------------------------


// asyncronous function for find users using userId -----------------------------------------------------

User.findUserById = async (userId) =>{
    const connection = await dbConnection();
    let sqlquery="SELECT * FROM user WHERE id=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[userId]);
    console.log(response);
    const data=response.length!=0?new User({
        id : response[0].id,
        name : response[0].name,
        dob : response[0].dob,
        email: response[0].email,
        mob: response[0].mob,
        gender: response[0].gender,
        pic: response[0].pic,
        type: response[0].type,
        hash: response[0].hash,
        salt: response[0].salt,
        buildingNumber: response[0].buildingnumber,
        locality:response[0].locality,
        pinCode: response[0].pincode,
        city : response[0].city,
        streetName: response[0].streetname,
        storeId: response[0].storeid,
    }):null;
    return {'noOfUserFound': response.length,'user':data };
};

// template of calling function--------------------------

// User.findUserById(2).then(data =>{
//     if(data.noOfUserFound==0){
//         console.log("No user found");
//     }
//     console.log(data.userList)
// }).catch(error => {
//     console.log('error: ', error);
// });

//-------------------------------------------------------------------------------------------------------


// asyncronous function for find users using userId -----------------------------------------------------

User.findUserByEmail = async (userEmail) =>{
    console.log("user: "+userEmail);
    const connection = await dbConnection();
    let sqlquery="SELECT * FROM user WHERE email=?";
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,[userEmail]);
    let data=response.length!=0?new User({
        id : response[0].id,
        name : response[0].name,
        dob : response[0].dob,
        email: response[0].email,
        mob: response[0].mob,
        gender: response[0].gender,
        storeId: response[0].storeid,
        pic: response[0].pic,
        type: response[0].type,
        hash: response[0].hash,
        salt: response[0].salt,
        buildingNumber: response[0].buildingnumber,
        locality:response[0].locality,
        pinCode: response[0].pincode,
        city : response[0].city,
        streetName: response[0].streetname,
    }):null;
    return {'noOfUserFound': response.length,'user': data};
};

// template of calling function--------------------------

// User.findUserByEmail('kdsanskar07@gmail.com').then(data =>{
//     if(data.noOfUserFound==0){
//         console.log("No user found");
//     }
//     console.log(data.userList)
// }).catch(error => {
//     console.log('error: ', error);
// });

//-------------------------------------------------------------------------------------------------------


// asyncronous function for update userdetail using userId -----------------------------------------------------

User.update = async (userData,userId) =>{
    const connection = await dbConnection();
    let sqlquery="UPDATE user SET name=?,email=?,dob=?,mob=?,gender=?,pic=?,type=?,pincode=?,locality=?,city=?,buildingnumber=?,streetname=? WHERE id = ?";
    const val = [userData.name,userData.email,userData.dob,userData.mob,userData.gender,userData.pic,userData.type,userData.pinCode,userData.locality,userData.city,userData.buildingNumber,userData.streetName,userId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    // connection.close;
    return {'affectedNoOfRows': response.affectedRows};
};

//-------------------------------------------------------------------------------------------------------


// asyncronous function for update userPassword using userId -----------------------------------------------------

User.updatePassword = async (userData,userId) =>{
    const connection = await dbConnection();
    let sqlquery="UPDATE user SET hash=?,salt=? WHERE id = ?";
    const val = [userData.hash,userData.salt,userId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    // connection.close;
    return {'affectedNoOfRows': response.affectedRows};
};

User.updateStoreId = async (connection,storeId,userId) =>{
    let sqlquery="UPDATE user SET type='2',storeid=? WHERE id = ?";
    const val = [storeId,userId];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    // connection.close;
    return {'affectedNoOfRows': response.affectedRows};
};

User.updateStoreIdHelper = async (connection,storeId,email) =>{
    let sqlquery="UPDATE user SET type='3',storeid=? WHERE email = ?";
    const val = [storeId,email];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    // connection.close;
    return {'affectedNoOfRows': response.affectedRows};
};

User.removeStoreIdHelper = async (connection,email) =>{
    let sqlquery="UPDATE user SET type='1' WHERE email = ?";
    const val = [email];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    // connection.close;
    return {'affectedNoOfRows': response.affectedRows};
};

// template of calling function--------------------------

// let userdata = new User({
//     email: '1@gmail.com',
//     hash: 'gbhcnslkcmsokcnsonciwhvnk',
//     salt: 'dcbnxsckscnslmls',
// });
// userdata.dob = '12 mar 2000';
// userdata.mob = '8808080000';
// userdata.gender = 'male';
// userdata.type = 2;
// userdata.pic = 'thisispic';
// userdata.name = 'user1';

// User.update(userdata).then(data =>{
//     console.log('affectedNoOfRows: ',data.affectedNoOfRows);
// }).catch(error => {
//     console.log('error: ', error);
// });

//-------------------------------------------------------------------------------------------------------


module.exports = User;
