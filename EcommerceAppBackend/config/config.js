const dotenv = require('dotenv');
dotenv.config();

const fs = require('fs');
const path = require('path');
const pathToKey_pub = path.join(__dirname, '..', 'id_rsa_pub.pem');
const PUBLIC_KEY = fs.readFileSync(pathToKey_pub, 'utf8');
const pathToKey_priv = path.join(__dirname, '..', 'id_rsa_priv.pem');
const PRIVATE_KEY = fs.readFileSync(pathToKey_priv, 'utf8');

module.exports = {
    "development": {
      "username": process.env.DB_USER,
      "password": process.env.DB_PASSWORD,
      "database": process.env.DB_NAME,
      "host": process.env.HOST,
      "dialect": process.env.DIALECT,
      "port": process.env.PORT,
      "public_key": PUBLIC_KEY,
      "private_key": PRIVATE_KEY,
      "senderEmail": process.env.SENDER_EMAIL,
      "senderPassword": process.env.SENDER_PASSWORD,
    },
    // "test": {
    //   "username": "root",
    //   "password": null,
    //   "database": "database_test",
    //   "host": "127.0.0.1",
    //   "dialect": "mysql"
    // },
    // "production": {
    //   "username": "root",
    //   "password": null,
    //   "database": "database_production",
    //   "host": "127.0.0.1",
    //   "dialect": "mysql"
    // }
  };
