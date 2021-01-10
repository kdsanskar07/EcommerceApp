const router = require('express').Router();   
const bookmarkController = require('../controllers/bookmark.js');
const passport = require('passport');

router.post('/create',passport.authenticate('jwt',{session:false}),bookmarkController.createBookmark);

router.post('/delete',passport.authenticate('jwt',{session:false}),bookmarkController.deleteBookmark);

router.post('/check',passport.authenticate('jwt',{session:false}),bookmarkController.checkStore);

router.get('/fetch',passport.authenticate('jwt',{session:false}),bookmarkController.fetchBookmarks);

module.exports = router;