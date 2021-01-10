const nodemailer = require('nodemailer');
const Config = require('../config/config.js');

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: Config.development.senderEmail,
    pass: Config.development.senderPassword
  }
});

const sendEmail = async (email,otp) =>{
  return new Promise((resolve,reject)=>{
    const mailOptions =  {
      from: Config.development.senderEmail,
      to: email,
      subject: 'Sending Email using Node.js',
      text: otp
    };
  
    transporter.sendMail(mailOptions,(error,res) => {
      if(error) {
        reject(error);
      }
      resolve(true);
    });
  })
};


module.exports.transporter = transporter; 
module.exports.sendEmail = sendEmail;