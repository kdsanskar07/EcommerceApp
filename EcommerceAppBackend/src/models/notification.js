const dbConnection = require("../../config/database.js");
const executeQueryInsertSelectUpdate= require("./index.js").executeQueryInsertSelectUpdate;


const Notification = function(notification){
    this.img = notification.img ;
    this.summary = notification.summary;
    this.title = notification.title;
    this.expireDate = notification.expireDate;
}

Notification.createNotification = async (notificationData) =>{
    const connection = await dbConnection();
    let sqlquery="INSERT INTO notification (img,summary,title,expiredate) VALUES (?,?,?,?)";
    const val = [notificationData.img,notificationData.summary,notificationData.title,10];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'id': response.insertId};
}

Notification.dailyRun = async () =>{
    const connection =await dbConnection();
    let sqlquery = "UPDATE notification SET expiredate = expiredate - 1";
    let val = [];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

Notification.dailyRunDelete = async () =>{
    const connection =await dbConnection();
    let sqlquery = "DELETE FROM notification WHERE expiredate = 0";
    let val = [];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'affectedNoOfRows': response.affectedRows};
}

Notification.getNotification = async () =>{
    const connection =await dbConnection();
    let sqlquery = "SELECT * FROM notification";
    let val = [];
    const response = await executeQueryInsertSelectUpdate(connection,sqlquery,val);
    return {'noOfUserFound': response.length,'user': response};
}
