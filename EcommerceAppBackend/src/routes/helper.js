const router = require('express').Router();   
const helper = require('../controllers/helper.js');
const passport = require('passport');

router.post('/verify', passport.authenticate('jwt',{session:false}),helper.verifyHelper);
router.post('/resendotp', passport.authenticate('jwt',{session:false}),helper.resendOtp);
router.get('/getstorehelpers', passport.authenticate('jwt',{session:false}),helper.getStoreHelpers);
router.post('/removehelper', passport.authenticate('jwt',{session:false}),helper.removeHelper);
router.post('/createhelper', passport.authenticate('jwt',{session:false}),helper.createHelper);


module.exports = router;