var express = require('express');
var app = express();

var requestTime = function (req, res, next) {
  req.requestTime = Date.now();
  console.log('first');
  next();
};

console.log('I am in test.js');
var x = 10;

app.use(requestTime);

var callback = function(req,res,next){

	console.log('I am here');
	next();
}

app.use(callback);

app.get('/', function (req, res) {
  var responseText = 'Hello World!';
  responseText += 'Requested at: ' + req.requestTime + '';
  res.send(responseText);
});

app.listen(3000);

module.exports.num = function t(){
console.log('I am in testttttttt function.js');
console.log(x);

};