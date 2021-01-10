const router = require('express').Router();   
const notificationController = require('../controllers/notification.js');
const passport = require('passport');

router.get('/getnotification',passport.authenticate('jwt',{session:false}),notificationController.getNotifications);

router.post('/createnotification',notificationController.createNotification);

module.exports = router;