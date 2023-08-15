const express = require('express');
const mongoose = require('mongoose');
const nodemailer = require('nodemailer');
const cron = require('node-cron');
const bodyParser = require('body-parser');
const fs = require('fs');

const app = express();
const port = 3000;

// MongoDB connection
mongoose.connect('mongodb+srv://admin:admin@cluster0.o8soijt.mongodb.net/?retryWrites=true&w=majority', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
const db = mongoose.connection;
const authorizedEmail = "sumit.spofficial223@gmail.com";


require.extensions['.txt'] = function (module, filename) {
    module.exports = fs.readFileSync(filename, 'utf8');
};

const defaultImage= require("./base64.txt");

console.log(typeof defaultImage);


db.once('open', () => {
  console.log('Connected to MongoDB');

  const memorySchema = new mongoose.Schema({
    title: {type: String, required: true},
    content: {type: String, required: true},
    eventDate: {type: Date, required: true},
    createdDate: { type: Date, default: Date.now },
    lastSentDate: { type: Date, default: Date.now },
    tag: {type: String, default: "demoTag"},
    image: {type: String, default: defaultImage}
    
  });

  const Memory = mongoose.model('Memory', memorySchema);

  // Set up your email transport configuration here
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: authorizedEmail, // Replace with your Gmail email address
        pass: '<PassWord>', // Replace with your Gmail password or app password
    },
  });

  // Schedule the email sending process to run daily at a specific time
  // cron.schedule('* * * * *', sendEmail);

  // Middleware to parse JSON request bodies
  app.use(bodyParser.json());
 

  // Add a memory
  app.post('/add', async (req, res) => {
    try {
      const { title, content, eventDate, tag, image } = req.body;
      const memory = new Memory({ title, content, eventDate, tag, image });
      await memory.save();
      res.status(201).json({ message: 'Memory added successfully' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

  // Retrieve all memories
  app.get('/getMemory', async (req, res) => {
    try {
      const memories = await Memory.find();
      res.status(200).json({"status":'OK', "result": memories});
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });


  // Send email
  async function sendEmail() {
    try {
      const today = new Date();
      const memoryToSend = await Memory.findOne({
        $or: [{ lastSentDate: null }, { lastSentDate: { $lt: today } }],
      }).sort({ eventDate: 1 });

      if (memoryToSend) {
        const userEmail = memoryToSend.userEmail;
        // Send email logic here using the 'transporter' created above
        const mailOptions = {
          from: authorizedEmail,
          to: userEmail,
          subject: 'Daily Memory',
          text: `Title: ${memoryToSend.title}\nContent: ${memoryToSend.content}`,
        };

        transporter.sendMail(mailOptions, (error, info) => {
          if (error) {
            console.error('Error sending email:', error);
          } else {
            console.log('Email sent successfully:', info.response);
          }
        });

        // Update the lastSentDate for the memory
        await Memory.findByIdAndUpdate(memoryToSend._id, {
          lastSentDate: today,
        });
      } else {
        console.log('No memories to send');
      }
    } catch (error) {
      console.error('An error occurred:', error);
    }
  }

  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });
});
