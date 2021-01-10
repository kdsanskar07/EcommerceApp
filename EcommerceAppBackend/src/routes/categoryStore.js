const router = require('express').Router();   
const categoryStoreController = require('../controllers/categoryStore.js');
const passport = require('passport');


router.get('/getcategorylist',passport.authenticate('jwt',{session:false}),categoryStoreController.getCategoryList);

module.exports = router;