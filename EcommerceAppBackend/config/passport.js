const JwtStrategy = require('passport-jwt').Strategy
const ExtractJwt = require('passport-jwt').ExtractJwt;
const User = require('../src/models/user.js');
const Config = require('./config.js');

const PUB_KEY = Config.development.public_key;


// this all the available options --- this just for future reference actuall otipn is just below 

// const passportJWTOptions = {
//     jwtFromRequest : ExtractJwt.fromAuthHeaderAsBearerToken(),
//     secretOrKey : PUB_KEY,
//     issuer: 'enter issuer here',
//     audience: 'enter audience here',
//     algorithms: ['RS256'],
//     ignoreExpiration: false,
//     passReqTocallback: false,
//     jsonWebTokenOptions:{
//         complete: false,
//         clockTolerance: '',
//         clockTimestamp: '100',
//         nonce: 'string here for openID',
//     }
// }



const options = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: PUB_KEY,
  algorithms: ['RS256']
};

const strategy = new JwtStrategy(options,(payload,done)=>{
  User.findUserById(payload.sub).then((data)=>{
     if(data.noOfUserFound==0){
       done(null,false);
     }else{
       done(null,data.user);
     }
    }).catch((error)=>{
      done(error,null);
    });
});

// app.js will pass the global passport object here, and this function will configure it
module.exports = (passport) => {
    passport.use(strategy);
}