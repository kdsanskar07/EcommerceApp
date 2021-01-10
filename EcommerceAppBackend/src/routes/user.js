const router = require('express').Router();   
const userController = require('../controllers/user.js');
const passport = require('passport');

router.post('/register', userController.register);

router.post('/verify', userController.verifyUser);

router.post('/resendotp',userController.resendOTP);

router.post('/login', userController.login);

router.post('/forgetPassword',userController.forgetPassword);

router.post('/verifyOtp',userController.verifyOtp);

router.post('/resetPassword',userController.resetPassword);

router.post('/resendOtpReset',userController.resendOTPReset);

router.get('/getuserdetail', passport.authenticate('jwt',{session: false}),userController.getUserDetail);

router.post('/updateuserdetail', passport.authenticate('jwt',{session: false}),userController.updateUserDetail);

module.exports = router;