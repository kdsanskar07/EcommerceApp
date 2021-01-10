const CategoryStore = require('../models/categoryStore.js').CategoryStore;

const getCategoryList = async (req,res) => {
    try{
        const response = await CategoryStore.getCategoryList(req.user.storeId);
        //console.log(response);
        return res.status(200).json({success:true, data : response});
    }catch(error){
       // console.log(error);
        return res.status(400).json({success:false,msg:"Please refresh the Page."});
    }
}

module.exports.getCategoryList = getCategoryList;