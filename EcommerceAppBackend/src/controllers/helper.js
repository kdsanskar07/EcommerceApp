const { response } = require('express');
const Helper = require('../../src/models/helper.js');
const User = require('../models/user.js');
const mailSender = require('../../lib/mail.js');

// const getHelpers = async (req,res) => {
//     try{
//         const response = await Helper.getHelper(req.user.storeId,req.body.email);
//         res.status(200).json({success:true,data:response});
//     }catch(error){
//         console.log(error);
//         return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
//     }
// }

const verifyHelper = async (req,res) => {
    try{
        const helperResponse = await Helper.getHelper(req.user.storeId,req.body.email);
        if(req.body.otp==helperResponse.helper.otp){
            const verifyResponse = await Helper.verifyHelperTransaction(req.user.storeId,req.body.email);
            res.status(200).json({success:true,msg:verifyResponse.msg});
        }else{
            return res.status(400).json({success:false,msg:'Otp did not match, Please retry.'});
        }
    }catch(error){
        return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
    }
}

const resendOtp = async (req,res) => {
    try{
        const response = await Helper.resendOtp(req.user.storeId,req.body.email);
        if(response.noOfHelperFound>0){
            await mailSender.sendEmail(req.body.email,response.helperOtp);
            res.status(200).json({success:true,msg:"Otp is sent to helper's email."});
        }else{
            return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
        }
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
    }
}

const removeHelper = async (req,res) => {
    try{
        const response = await Helper.removeHelperTransaction(req.user.storeId,req.body.email);
        res.status(200).json({success:true,msg:"Helper is Removed."});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
    }
}

const createHelper = async (req,res) => {
    // console.log("bchnj");
    try{
        // console.log("bchnj");
        const userResponse = await User.findUserByEmail(req.body.email);
        if(userResponse.noOfUserFound==0){
            return res.status(400).json({success:false,'msg': "Email not registered with us."});
        }else{
            if(userResponse.user.type!=1){
                return res.status(400).json({success:false,'msg': "User with this email can't become helper."});
            }
            // console.log("bhnjm");
            let otpval = Math.floor(100000 + Math.random() * 900000).toString();
            console.log(otpval);
            const newHelper = new Helper({
                email : userResponse.user.email,
                storeId : req.user.storeId,
                otp : otpval,
                isVerified : 0,
                name :userResponse.user.name,
            });
            // console.log(otp);
            const response = await Helper.addHelper(newHelper);
            // console.log(otp);
            console.log(response);
            const responsemail = await mailSender.sendEmail(req.body.email,otpval);
            // console.log(otp);
            return res.status(200).json({success:true,msg:'OTP has been to helpers email,Please verify it.'});
        }
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
    }
}

const getStoreHelpers = async (req,res)=>{
    try{
        const response = await Helper.getStoreHelper(req.user.storeId);
        res.status(200).json({success:true,data:response});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong, Please retry.'});
    }
}



// module.exports.getHelpers = getHelpers;
module.exports.getStoreHelpers = getStoreHelpers;
module.exports.verifyHelper = verifyHelper;
module.exports.resendOtp = resendOtp;
module.exports.createHelper= createHelper;
module.exports.removeHelper = removeHelper;





