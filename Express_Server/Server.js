/****************
 /SQLQuery.json
 {"connect":{"Name":"sa","Pas":"11111Sa","Server":"10.73.135.131","DB":"Test"},"SQLText":"select * from [Test].[dbo].[target]"}
 ****************/

 console.log_plus = function (log, fs, fd){
	now = new Date(); now = now.getFullYear()+'.'+now.getMonth()+'.'+now.getDate()+' '+now.getHours()+':'+now.getMinutes()+':'+now.getSeconds();
	console.log(now + ' -> '+ log);
	if (fs !== undefined && fd !== undefined) fs.write(fd, now+' -> '+log+'\n',(err) => {if (err) console.log(err);});	
}

var express = require("express");
var DOMParser = require('xmldom').DOMParser;
var app = express();
var fs = require('fs');
var fd = null;
var qr = require('qr-image');
var https = require('https');
fs.open(__dirname +'/log.txt', 'a+', (err, _fd) => {if (!err) {fd=_fd;} else console.log(err);});
var port = 80;

var SQLConnection = require('tedious').Connection;
var SQLRequest = require('tedious').Request;

app.get(/^(.+)$/, function(req, res){
	var client_ip=req.headers['x-forwarded-for'] || req.connection.remoteAddress || req.socket.remoteAddress || req.connection.socket.remoteAddress;
	console.log_plus('IP:'+client_ip+' static file request (GET metod): ' + req.params[0],fs,fd);
	switch (req.params[0]) {
	case '/':
		res.sendFile(__dirname + "/html/index.html");
		break;
	case '/QR':
		var code = qr.image(req.query.text, { type: 'png' });
		res.setHeader('Content-type', 'image/png');  //sent qr image to client side
		code.pipe(res);
		break;
	case '/SendSMS': // http://10.73.135.150/SendSMS?mes=Привет МИР!&target=+79191920025,+79611046780 http://10.73.135.150/SendSMS?operation=status&id=8969295804
		res.setHeader('Content-type', 'text/xml');
		var post_data = '';
		if (req.query.operation!=undefined) {
			if (req.query.operation='status') post_data = 'gzip=none&action=status&sms_id='+(req.query.id!=undefined?req.query.id:'')+'&user=731600&pass=qwerty1234&CLIENTADR=&HTTP_ACCEPT_LANGUAGE=';
		} else post_data = 'gzip=none&action=post_sms&message='+encodeURI((req.query.mes!=undefined?req.query.mes:''))+'&sender='+(req.query.sender!=undefined?req.query.sender:'')+'&smstype=SENDSMS&target='+(req.query.target!=undefined?req.query.target:'')+'&user=731600&pass=qwerty1234&CLIENTADR=&HTTP_ACCEPT_LANGUAGE=';
		var options = {
			hostname: 'beeline.amega-inform.ru',
			port: 443,
			path: '/sms_send/',
			method: 'POST',
			headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		}
		var req_sms = https.request(options, (req_sms) => {
			req_sms.on('data', (d) => {
				if (req_sms.statusCode==200) {
/*					var parserXML = new DOMParser();
					var xmldata = parserXML.parseFromString(d.toString(),"text/xml");
					var Abonent = xmldata.getElementsByTagName("result")[0].firstChild;
					var OutStr='';
					while (Abonent!=undefined){
						OutStr += 'id='+Abonent.getAttribute('id')+'; phone='+Abonent.getAttribute('phone');
						Abonent = Abonent.nextSibling;
					}
					res.send(OutStr);*/
					res.send(d.toString());
				} else res.send(req_sms.statusCode);
			});
		});
		req_sms.on('error', (e) => {
			res.send(e.toString());
		});
		req_sms.write(post_data);
		req_sms.end();
		break;
	case '/chekonline_test':
		res.setHeader('Content-type', 'application/json');
		if (req.query.op !== undefined)
			res.send('{"Response":"'+req.query.op+'"}');
		else
			res.send('{"Response":"undefined"}');
		break;
	case '/chekonline': //10.73.135.150/chekonline?m=10000&l=000111 or //10.73.135.150/chekonline?m=10000&l=000111&op=2
		res.setHeader('Content-type', 'application/json');
		if (req.query.test !== undefined)
			res.send('{"Response":"l='+req.query.l+', m='+req.query.m+', op='+req.query.op+'"}');
		else
		{
			var post_data = '{"Device":"auto",'+
				'"RequestId":"'+'H'+(new Date().getTime()).toString(16)+'R'+parseInt(Math.random()*65535).toString(16)+'",'+
				'"Lines":[{"Qty":1000,"Price":'+req.query.m+',"PayAttribute":4,"LineAttribute":4,"TaxId":1,"Description":"Оплата за ТО ВДГО"}],'+
				'"NonCash":['+req.query.m+'],'+
				'"TaxMode":1,'+
				'"PhoneOrEmail":"chek-online@gro32.ru",'+
				//'"PhoneOrEmail":"chmyhovdv@gro32.ru",'+
				'"Place":"РФ, 241050, Брянская область, город Брянск, улица Щукина, дом 54"';
				if (req.query.op !== undefined)
					post_data += ',"DocumentType":'+req.query.op;
				else
					post_data += ',"DocumentType":0';
				post_data += ',"UserRequisite":{"Title":"ЛицевойСчет","Value":"'+req.query.l+'"}}';
			var options = {
				hostname: 'kkt4.chekonline.ru',//'fce.chekonline.ru kkt.chekonline.ru',
				port: 443,
				path: '/fr/api/v2/Complex',
				method: 'POST',
				headers: {'Content-Type': 'application/json'},
				key: fs.readFileSync(__dirname +'/SSL/privateKey.pem'),
				cert: fs.readFileSync(__dirname +'/SSL/certificate.pem')
				//key: fs.readFileSync(__dirname +'/SSL/privateKey_test.pem'),
				//cert: fs.readFileSync(__dirname +'/SSL/certificate_test.pem')  
			};
			var req_chekonline = https.request(options, (res_chekonline) => {
				res_chekonline.on('data', (d) => {
					if (res_chekonline.statusCode==200)	res.send(d.toString()); else res.send('{"Response":{"Error":-1,"ErrorMessages":["Код состояния HTTP '+res_chekonline.statusCode+'"]}}');
				});
			});
			req_chekonline.on('error', (e) => {
				res.send('{"Response":{"Error":-1,"ErrorMessages":["'+e.toString()+'"]}}');
			});
			req_chekonline.write(post_data);
			req_chekonline.end();
		}
		break;
	default:
		res.sendFile(__dirname + "/html" + req.params[0],(err) => {
			if (err) {
				console.log_plus('IP:'+client_ip+' requested file not found (GET metod) : ' + err,fs,fd);
				res.sendFile( __dirname + "/html/404.htm");
			}
		});
	}
 });

//POST функции
function SQLQuery(res,InputData){
	var Out = {}; Out.error=false; Out.errorText='';
	var SQLconfig = {userName: '',password: '',server: '',options: {encrypt: false, database: ''}};
	SQLconfig.userName = InputData.connect.Name;
	SQLconfig.password = InputData.connect.Pas;
	SQLconfig.server = InputData.connect.Server;
	SQLconfig.options.database = InputData.connect.DB;
	var SQLconnect = new SQLConnection(SQLconfig);
	SQLconnect.on('error', function(err) {console.log_plus(err.message,fs,fd);});
	SQLconnect.on('connect', function(err) {  
		if (err) {
			Out.error=true;
			Out.errorText = err.message;
			res.send(JSON.stringify(Out));
			SQLconnect = null;
		} else {						
			Out.Data = {};
			Out.Data.Rows = [];
			Out.Data.Cols = [];
			request = new SQLRequest(InputData.SQLText, function(err) {
				if (err) {
					Out.error=true;
					Out.errorText = err.message;
					console.log_plus('User:'+SQLconfig.userName+' SQL:'+InputData.SQLText+' ERROR!',fs,fd);
				} else {
					console.log_plus ('User:'+SQLconfig.userName+' SQL:'+InputData.SQLText+' WELL DONE',fs,fd);
				};
				res.send(JSON.stringify(Out));
				SQLconnect = null;
			});

			request.on('columnMetadata', function(columns) {
				columns.forEach(function(column) {
					Out.Data.Cols [Out.Data.Cols.length] = String(column.colName);
				});
			});

			request.on('row', function(columns) {
				var row = Out.Data.Rows.length;
				Out.Data.Rows[row] = [];
				columns.forEach(function(column) {
					if (column.value == null) { Out.Data.Rows[row] [Out.Data.Rows[row].length] = 'NULL'; } else {  
					Out.Data.Rows[row] [Out.Data.Rows[row].length] = String(column.value);} 
				});
			});
			SQLconnect.execSql(request);
		};
	});
};
//POST функции конец

 app.post(/^(.+)$/, function(req, res){
	var client_ip=req.headers['x-forwarded-for'] || req.connection.remoteAddress || req.socket.remoteAddress || req.connection.socket.remoteAddress;
	console.log_plus('IP:'+client_ip+' file request (POST metod): ' + req.params[0],fs,fd);
	var TextIn = '';
	req.on('data',function(chunk){ TextIn += chunk; } );
	req.on('end',function(){
		res.set('Content-Type', 'text/plain');
		res.setHeader('Access-Control-Allow-Origin', '*');
		var Out = {}; Out.error=false; Out.errorText='';
		switch (req.params[0]) {
		case '/SQLQuery.json':
			try {
				In = JSON.parse(TextIn);
				SQLQuery(res,In);
			} catch (err) {Out.error = true; Out.errorText='not json input data'; console.log_plus('IP:'+client_ip+' Input not JSON Data.',fs,fd); res.send(JSON.stringify(Out));}
			break;
		default:
			var Out = {}; 
			Out.Data = 'no processing for this file';
			res.send(JSON.stringify(Out));
		}
	});
 });

 app.listen(port, function() {
	console.log("Listening on " + port);
  });