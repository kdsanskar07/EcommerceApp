
// asyncronous functions for Query Execution ------------------------------------------------------------

const executeQueryCreateTable = async (connection,sqlquery)=>{
    return new Promise((resolve,reject)=>{
        connection.execute(sqlquery,(error,response)=>{
            if(error)  return reject(error);
            return resolve(response);
        });
    });
};

const executeQueryInsertSelectUpdate = async (connection,sqlquery,Data) =>{
    return new Promise((resolve,reject)=>{
        connection.query(sqlquery,Data,(error,response)=>{
            if(error) return reject({'sqlErrorCode': error.code,'sqlErrorNumber':error.errno,'errorMessage':error.sqlMessage});
            return resolve(response);
        });
    });
};

module.exports.executeQueryCreateTable = executeQueryCreateTable;
module.exports.executeQueryInsertSelectUpdate = executeQueryInsertSelectUpdate;

//------------------------------------------------------------------------------------------------------- 