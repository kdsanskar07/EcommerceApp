const User = require('../../src/models/user.js');
const utils = require('../../lib/utils.js');
const redis = require('redis');
const mailSender = require('../../lib/mail.js');

const { promisify } = require("util");

const redisClient = redis.createClient();
const otp = Math.floor(100000 + Math.random() * 900000).toString();

const login = (req,res)=>{
    console.log("req: "+req.body);
    User.findUserByEmail(req.body.email).then( data =>{
        if(data.noOfUserFound==0){
            return res.status(401).json({success: false,msg: "Email not registered"});
        }
        const isvalid =utils.validPassword(req.body.password,data.user.hash,data.user.salt);
        if(isvalid){
            const tokenObject = utils.issueJWT(data.user);
            return res.status(200).json({success:true,msg: 'user login successful',userid:data.user.id,token:tokenObject.token,expiresIn:tokenObject.expires});
        }else{
            return res.status(401).json({success:false,msg: 'Wrong password'})
        }
    }).catch(err =>{
        return res.status(400).json({success:false,error:err});
    });
};

const resendOTP = async (req,res)=>{
    const key = JSON.stringify({email:req.body.email,password:req.body.password});
    const getOtp = promisify(redisClient.get).bind(redisClient);
    var result = await getOtp(key);
    if(result){
        try{
            const response = await mailSender.sendEmail(req.body.email,result);
            return res.status(200).json({success:true,msg:'OTP has been sent.'});
        }catch{
            return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
        }
    }else{
        // email validate- --TODO
        let otp = Math.floor(100000 + Math.random() * 900000).toString();
        const key = JSON.stringify({email:req.body.email,password:req.body.password});
        const val = otp;
        redisClient.set(key,val);
        redisClient.expire(otp,86400); //24-hrs
        try{
            const response = await mailSender.sendEmail(req.body.email,otp);
            return res.status(200).json({success:true,msg:'OTP has been sent.'});
        }catch{
            return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
        }
    }
}


const register = async (req,res)=>{
    console.log(req.body.email);
    try{
    const response = await User.findUserByEmail(req.body.email);
    if(response.noOfUserFound){
        return res.status(400).json({success:false,msg:'Email already exist.'});
    }
    let otp = Math.floor(100000 + Math.random() * 900000).toString();
    const key = JSON.stringify({email:req.body.email,password:req.body.password});
    const val = otp;
    redisClient.set(key,val);
    redisClient.expire(otp,86400); //24-hrs
    const responsemail = await mailSender.sendEmail(req.body.email,otp);
    return res.status(200).json({success:true,msg:'OTP has been sent.'});
    }catch(error){
        console.log(error);
       return res.status(400).json({success:false,msg:'Please retry.'});
    }
};

const verifyUser = async (req,res)=>{
    const key = JSON.stringify({email:req.body.email,password:req.body.password});
    const getAsync = promisify(redisClient.get).bind(redisClient);
    var result = await getAsync(key);
    if(result){
        // console.log(req.body.otp);
        // console.log(result);
        if(req.body.otp==result){
            const saltHash =utils.genPassword(req.body.password);
            const salt =saltHash.salt;
            const hash =saltHash.hash;

            const newUser = new User({
                email: req.body.email,
                hash: hash,
                salt: salt
            });

            User.createUser(newUser).then((user)=>{
                const jwt = utils.issueJWT(user);
                return res.status(200).json({success:true, userId:user.id,token:jwt.token ,expiresIn:jwt.expires});
            }).catch((error)=>{
                return res.status(400).json({success: false, error: error});
            })
        }else{
            return res.status(400).json({success:false,msg:'Enter valid OTP.'});
        }
    }else{
        return res.status(400).json({success:false,msg:'Otp expired! Please register again.'});
    }
};

const forgetPassword = async(req,res) =>{
    const response = await User.findUserByEmail(req.body.email);
    if(!response.noOfUserFound){
        return res.status(400).json({success:false,msg:'Email does not exist.'});
    }
    let otp = Math.floor(100000 + Math.random() * 900000).toString();
    const key = req.body.email;
    console.log('key1: ',key);
    const val = otp;
    redisClient.set(key,val);
    redisClient.expire(otp,86400); //24-hrs
    try{
        const response = await mailSender.sendEmail(req.body.email,otp);
        return res.status(200).json({success:true,msg:'OTP has been sent.'});
    }catch{
       return res.status(400).json({success:false,msg:'Please retry.'});
    }
}

const verifyOtp = async(req,res) => {
    const key = req.body.email;
    const getAsync = promisify(redisClient.get).bind(redisClient);
    try{
        var result = await getAsync(key);
        if(result){
            if(req.body.otp===result){
                return res.status(200).json({success:true,msg:'OTP verified'});
            }
            else{
                return res.status(400).json({success:false,msg:'Incorrect OTP'});
            }
        }
        else{
            return res.status(400).json({success:false,msg:'Otp expired! Please provide email again'});
        }
    }catch{
        return res.status(400).json({success:false,msg:'Please retry again'});
    }
}

const resetPassword = async(req,res) => {
    const response = await User.findUserByEmail(req.body.email);
    if(!response.noOfUserFound){
        return res.status(400).json({success:false,msg:'Email does not exist.'});
    }
    const saltHash =utils.genPassword(req.body.password);
    console.log(req.body);
    const salt =saltHash.salt;
    const hash =saltHash.hash;
    var data = response.user;
    console.log(data);
    data.salt = salt;
    data.hash = hash;
    console.log(data);
    User.updatePassword(data,data.id).then((result)=> {
        console.log(result);
        if(result.affectedNoOfRows){
            return res.status(200).json({success:true, msg:'Password updated sucessfully'});
        }
        else{
            return res.status(400).json({success:false,msg:'Please retry again'});
        }
    }).catch(err =>{
        console.log(err);
        return res.status(400).json({success:false,msg:'Please retry again'});
    });
}

const resendOTPReset = async (req,res)=>{
    const key = req.body.email;
    const getOtp = promisify(redisClient.get).bind(redisClient);
    var result = await getOtp(key);
    if(result){
        try{
            const response = await mailSender.sendEmail(req.body.email,result);
            return res.status(200).json({success:true,msg:'OTP has been sent.'});
        }catch{
            return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
        }
    }else{
        let otp = Math.floor(100000 + Math.random() * 900000).toString();
        const key = req.body.email;
        const val = otp;
        redisClient.set(key,val);
        redisClient.expire(otp,86400); //24-hrs
        try{
            const response = await mailSender.sendEmail(req.body.email,otp);
            return res.status(200).json({success:true,msg:'OTP has been sent.'});
        }catch{
            return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
        }
    }
}

const getUserDetail = (req,res)=>{
    if(req.error!=null)
        return res.status(400).json({success:false,msg:"Something went wrong! Please retry"});
    req.user.hash = null;
    req.user.salt = null;
    return res.status(200).json({success:true, data:req.user});
};

const updateUserDetail = (req,res) => {
    User.update(req.body,req.user.id).then(data=>{
        return res.status(200).json({success:true, msg: "Profile Updated."});
    }).catch(error=>{
        return res.status(400).json({success:false,msg:"Something went wrong! Please retry"});
    })
}

module.exports.register =register;
module.exports.login = login;
module.exports.verifyUser = verifyUser;
module.exports.resendOTP = resendOTP;
module.exports.getUserDetail = getUserDetail;
module.exports.updateUserDetail=updateUserDetail;
module.exports.forgetPassword = forgetPassword;
module.exports.verifyOtp = verifyOtp;
module.exports.resetPassword = resetPassword;
module.exports.resendOTPReset = resendOTPReset;