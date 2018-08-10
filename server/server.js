const express = require('express');
const app = express();
app.use(express.json());

var request = require('request');
var jp = require('jsonpath');


app.post('/api/*', (req, res) => { 

	var request = require("request");
	
	console.log('Request body ' + JSON.stringify(req.body));
	console.log('Request URL - ' + req.body.url);
	console.log('Request Content - ' + req.body.content);

	
	request.post({
        "headers": { "content-type": "application/json" },
        "url": req.body.url,
        "body": JSON.stringify(req.body.content),
        "auth": {
            "user": "gbandasha",
            "pass": "Nish@123",
            "sendImmediately": true
          }
    }, (error, response, body) => {
        if(error) {
            return console.dir(error);
        }
        console.dir('Response Body - ' + JSON.stringify(body));
        
        res.setHeader('Content-Type', 'application/json');
        res.send(body);
    });

	
	

});


app.listen(3000, () => console.log('Server listening on port 3000!'))