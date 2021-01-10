const router = require('express').Router();

router.use('/users', require('./user.js'));
router.use('/store', require('./store.js'));
router.use('/notification', require('./notification.js'));
router.use('/product', require('./product.js'));
router.use('/categorystore', require('./categoryStore.js'));
router.use('/order', require('./order.js'));
router.use('/helper', require('./helper.js'));
router.use('/bookmark', require('./bookmark.js'))
module.exports = router;