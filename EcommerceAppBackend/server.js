const express = require("express");
const passport = require('passport');

const app = express();

const Config= require("./config/config.js");

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

require('./config/passport.js')(passport);

app.use(passport.initialize());

// set port, listen for requests

app.use(require('./src/routes/index.js'));


app.listen(Config.development.port,err => {
  if(err) {
    throw err;
    console.log('Cannot listen server');
  }
  console.log("Server is running on port 3000.");
});
