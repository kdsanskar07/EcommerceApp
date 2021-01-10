
# initialization -- commands --terminal

npm init
npm install --save express passport dotenv nodemailer redis mysql2 jsonwebtoken
npm install nodemon --save-dev

# run command

node server.js
nodemon server.js


models :-

//flutter_secure_storage--- expiry date,token,email,password -- always check expiry date before sending request
    
user  -- name,email(unique),mob,dob,gender,hash,salt,pic,id,type,currentlocation
orders -- id,status(1-unPlaced,2-inTransit,3-readyToPickup,4-picked,5-cancel,6-accepted),storeid,userid,orderplacedate,orderplacetime,paymenttime,processedtime,pickuptime,ordertotal
orderproduct -- orderid,productid,categoryid,quantity
product -- id,price,pic,name,categoryid,storeid,description,totalquantity,unit
bookmarks -- userid,storeid
notification -- id,img,description,title,createdat
store -- id,img,userid,buildingNumber,streetname,locality,city,pincode,name,mon_openingtime,mon_closingtime..sun,mob,rating,description,revenue,nooforders
categorystore -- storeid,categoryid,noOfProducts
helperstore -- userid,storeid
storeopenday -- monday,tuesday,wednesday,thursday,friday,saturday,sunday




# mysql db commands
user :-
    "CREATE TABLE user(
        id INT AUTO_INCREMENT PRIMARY KEY,
        storeid INT,
        name VARCHAR(300) ,
        email VARCHAR(300) UNIQUE,
        hash VARCHAR(300) ,
        salt VARCHAR(300),
        dob varchar(300),
        gender varchar(20),
        mob varchar(12),
        pic varchar(300),
        type varchar(2),
        buildingnumber varchar(20),
        streetname varchar(20),
        locality varchar(20),
        city varchar(20),
        pincode varchar(20),
        index userindx (email)
);",
    "INSERT INTO user (name,email,hash,salt,dob,gender,mob,pic,type) VALUES (?,?,?,?,?,?,?,?,?)",
    "SELECT * from user where email=?",
    "SELECT * from user where id=?",

store :-
    "CREATE TABLE IF NOT EXISTS store(
        id INT AUTO_INCREMENT PRIMARY KEY,
        userid INT UNIQUE not null ,
        buildingnumber varchar(5),
        streetname VARCHAR(100),
        locality VARCHAR(100),
        pincode VARCHAR(6) NOT NULL,
        name VARCHAR(20) NOT NULL,
        openingtime VARCHAR(10),
        closingtime VARCHAR(10),
        mob VARCHAR(12),
        img VARCHAR(255),
        rating VARCHAR(10) ,
        revenue VARCHAR(20),
        nooforders VARCHAR(20),
        isopenonmonday INT,
        isopenontuesday INT,
        isopenonwednesday INT,
        isopenonthursday INT,
        isopenonfriday INT,
        isopenonsaturday INT,
        isopenonsunday INT,
        index storeindx (userid,pincode),
        CONSTRAINT fk_user_store FOREIGN KEY(userid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);"

orders :-
    "CREATE TABLE IF NOT EXISTS orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        status INT,
        storeid INT,
        userid INT,
        placetime VARCHAR(30),
        paymenttime VARCHAR(30),
        processedtime VARCHAR(30),
        pickuptime VARCHAR(30),
        total VARCHAR(20),
        INDEX orderindx (storeid,userid),
        CONSTRAINT fk_store_order FOREIGN KEY(storeid) REFERENCES store(id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_user_order FOREIGN KEY(userid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
    );"

categorystore :-
        "CREATE TABLE IF NOT EXISTS categorystore(
            storeid INT,
            categoryid INT,
            noofproducts varchar(10),
            CONSTRAINT pk_categorystore PRIMARY KEY(storeid , categoryid),
            CONSTRAINT fk_store_categorystore FOREIGN KEY(storeid) REFERENCES store(id) ON DELETE CASCADE ON UPDATE CASCADE
        );"

product :-
        "CREATE TABLE IF NOT EXISTS product (
           id INT AUTO_INCREMENT PRIMARY KEY,
           price VARCHAR(40),
           name VARCHAR(40),
           img VARCHAR(300),
           categoryid INT,
           storeid INT,
           description VARCHAR(200),
           totalquantity VARCHAR(20),
           unit VARCHAR(25),
           INDEX productindx (storeid),
           CONSTRAINT fk_store_product FOREIGN KEY(storeid) REFERENCES store(id) ON DELETE CASCADE ON UPDATE CASCADE
       );"
helper :-
       "CREATE TABLE IF NOT EXISTS helper (
            storeid INT,
            email VARCHAR(40),
            name VARCHAR(40),
            otp VARCHAR(10),
            isverifed INT
            CONSTRAINT pk_categorystore PRIMARY KEY(storeid , email),
            CONSTRAINT fk_store_product FOREIGN KEY(storeid) REFERENCES store(id) ON DELETE CASCADE ON UPDATE CASCADE
            CONSTRAINT fk_store_product FOREIGN KEY(email) REFERENCES user(email) ON DELETE CASCADE ON UPDATE CASCADE
       );"

orderproduct :-
    " CREATE TABLE IF NOT EXISTS orderproduct(
        orderid INT,
        productid INT,
        quantity VARCHAR(25),
        CONSTRAINT pk_orderproduct PRIMARY KEY (orderid,productid),
        CONSTRAINT fk_order_orderproduct FOREIGN KEY(orderid) REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT fk_product_orderproduct FOREIGN KEY(productid) REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE   
    );"


       

bookmarks :-
        " CREATE TABLE IF NOT EXISTS bookmark(
            userid INT,
            storeid INT,
            CONSTRAINT fk_user_bookmark FOREIGN KEY(userid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT fk_store_bookmark FOREIGN KEY(storeid) REFERENCES store(id) ON DELETE CASCADE ON UPDATE CASCADE
        );"

notification :-
        "CREATE TABLE IF NOT EXISTS notification(
            id INT AUTO_INCREMENT PRIMARY KEY,
            img VARCHAR(500),
            summary VARCHAR(250),
            title VARCHAR(50),
            expiredate int
        );"



//TODO

FlowChart of whole app
Logout par dhyan rakhna hai poora data delete karna hai usse pehle user ke cart ki asyncstorage ki info database main update karna hai
    