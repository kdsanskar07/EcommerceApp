const router = require('express').Router();   
const storeController = require('../controllers/store.js');
const passport = require('passport');

router.post('/register',passport.authenticate('jwt',{session:false}),storeController.register);

router.get('/getstoredetail',passport.authenticate('jwt',{session:false}),storeController.getStoreDetail);

router.post('/update',passport.authenticate('jwt',{session:false}),storeController.updateStore);

router.get('/getstoredetailpincode',passport.authenticate('jwt',{session:false}),storeController.getStorePincode);

module.exports = router;