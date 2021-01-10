const router = require('express').Router();
const orderController = require('../controllers/order.js'); 
const passport = require('passport');


router.get('/getCartDetails', passport.authenticate('jwt',{session:false}),orderController.getCartDetails);

router.post('/checkoutOrders',passport.authenticate('jwt',{session:false}),orderController.checkoutOrders);

router.post('/removeProduct',passport.authenticate('jwt',{session:false}),orderController.removeProduct);

router.get('/getUserOrders',passport.authenticate('jwt',{session:false}),orderController.getUserOrders);

router.post('/getOrderProduct',passport.authenticate('jwt',{session:false}),orderController.getOrderProduct);

router.get('/getStoreOrders',passport.authenticate('jwt',{session:false}),orderController.getStoreOrders);

router.post('/acceptStoreOrders',passport.authenticate('jwt',{session:false}),orderController.acceptStoreOrders);

router.post('/cancelStoreOrder',passport.authenticate('jwt',{session:false}),orderController.cancelStoreOrders);

router.post('/readyStoreOrder',passport.authenticate('jwt',{session:false}),orderController.readyStoreOrders);

router.post('/pickStoreOrder',passport.authenticate('jwt',{session:false}),orderController.pickStoreOrder);

router.post('/addToCart',passport.authenticate('jwt',{session:false}),orderController.addToCart);

module.exports = router;