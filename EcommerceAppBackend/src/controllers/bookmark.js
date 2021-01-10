const Bookmark = require('../models/bookmark.js');
const dbConnection = require("../../config/database.js");

const createBookmark = async function(req,res){
    try{
        // console.log("jhvbshdbfygvbsdfg");
        // console.log(req);
        const bookmarkResponse = await Bookmark.createBookmarkPage(req.body.storeid,req.user.id);
        console.log('response: ',bookmarkResponse);
        return res.status(200).json({success:true , msg:'Bookmark Created'});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

const deleteBookmark = async (req,res)=>{
    try{    
        const bookmarkResponse = await Bookmark.deleteBookmarkPage(req.body.storeid,req.user.id);
        console.log('response: ',bookmarkResponse);
        return res.status(200).json({success:true , msg:'Product Deleted'});
    }
    catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry'});
    }
};

const checkStore = async (req,res)=>{
    try{
        const checkResponse = await Bookmark.isPresent(req.body.storeid,req.user.id);
        console.log(checkResponse['data']);
        return res.status(200).json({success:true ,result: checkResponse['data']});
    } catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry.'});
    }
};

const fetchBookmarks = async (req,res)=>{
    try{
        const data = await Bookmark.fetchStoreTransaction(req.user.id);
        console.log('Fetch-Store:- ',data);
        return res.status(200).json({success:true, result: data});
    }catch(error){
        console.log(error);
        return res.status(400).json({success:false,msg:'Something went wrong! Please retry. '});
    }

};



module.exports.createBookmark = createBookmark;
module.exports.deleteBookmark = deleteBookmark;
module.exports.checkStore = checkStore;
module.exports.fetchBookmarks = fetchBookmarks;