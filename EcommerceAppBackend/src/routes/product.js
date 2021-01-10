const router = require('express').Router();
const productController = require('../controllers/product.js'); 
const passport = require('passport');


router.post('/createproduct', passport.authenticate('jwt',{session:false}),productController.createProduct);

router.post('/updateproduct', passport.authenticate('jwt',{session:false}),productController.updateProduct);

router.post('/deleteproduct', passport.authenticate('jwt',{session:false}),productController.deleteProduct);

router.post('/getproductlist', passport.authenticate('jwt',{session:false}),productController.getProductList);

module.exports = router;