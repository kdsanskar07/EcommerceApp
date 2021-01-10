const Config= require("./config.js");

const dbConnection = async () => {
    const mysql = require('mysql2/promise');
    const response = await mysql.createConnection({
        host: Config.development.host,
        user: Config.development.username,
        password:  Config.development.password,
        database: Config.development.database,
        waitForConnections: true,
        connectionLimit:10,
        queueLimit:0
    });
    const connection =response.connection;
    connection.connect(err =>{
        err? console.log("error connecting with db"): console.log("db connected on threadId: ",connection.threadId);
    });
    return connection;
};
module.exports = dbConnection;