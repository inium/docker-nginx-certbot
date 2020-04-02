const http = require('http');
const mysql = require('mysql');

const connection = mysql.createConnection({
    host     : process.env.MYSQL_HOST,
    user     : process.env.MYSQL_USER,
    password : process.env.MYSQL_PASSWORD,
});

const server = http.createServer(function (request, response) {
    connection.connect(function (err) {
        let connStatus = '';
        if (err) {
            connStatus = 'MySQL Connection Success: ' + err.stack;
        }
        else {
            connStatus = 'MySQL Connection Success';
        }

        response.writeHead(200, {'content-type': 'text/html'});
        response.end(`
            Hello, Node.js Simple Application!<br>
            ${connStatus}
        `);
    });
});

server.listen(80, function () {
    console.log("Server Listening on port number 80!");
});
